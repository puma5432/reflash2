"""Loopback TCP client for the SSF2 research bridge.

Wire protocol (newline-delimited JSON, matches tools/rl/ModAPI_patched.as):

  game -> client:
    {"type":"hello","api":...,"port":...,"framerate":...}
    {"type":"state","frame":N,"paused":0|1,"ended":0|1,"chars":[...]}
    {"type":"match_end"}   (ModAPI.deinit - match torn down)
    {"type":"match_ready","request":N,"generation":G,"state":...}
    {"type":"game_ended"}  (match reached an end condition)

    client -> game:
    {"type":"input","player":P,"bits":M}    hold input until replaced
    {"type":"takeover","player":P}          convert slot P to CPU control
    {"type":"ping"}                          -> {"type":"pong"}
    {"type":"state"}                         -> immediate extra snapshot
        {"type":"pause","request":N}            -> acknowledged paused snapshot
        {"type":"step","request":N}             -> one tick, then step_complete
        {"type":"resume","request":N}           -> acknowledged normal simulation

Only loopback endpoints are permitted.
"""

from __future__ import annotations

import json
import queue
import socket
import struct
import threading
import time
from collections import deque
from typing import Any, Optional

LOOPBACK_HOSTS = frozenset({"127.0.0.1", "::1", "localhost"})
DEFAULT_PORT = 4567
_BINARY_MAGIC = b"RLB3"
_EPISODE_MAGIC = b"EPI0"
_BINARY_HEADER = struct.Struct(">4sBBHI")
_EPISODE_HEADER = struct.Struct(">4siiI")
_BINARY_PREFIX = struct.Struct(">iiiBBBB")
_BINARY_CHAR = struct.Struct(">iffffBfhBhfHfi")
_MAX_BINARY_PAYLOAD = 1024 * 1024
_MAX_EPISODE_PAYLOAD = 64 * 1024 * 1024  # 64MB compressed


class BridgeError(RuntimeError):
    """Raised for protocol/connection violations."""


class SSF2Bridge:
    """Synchronous client with a background reader thread.

    States are buffered in a bounded queue; ``latest_state`` always returns the
    most recent snapshot, discarding stale ones (the game streams at 30 FPS).
    """

    def __init__(
        self,
        host: str = "127.0.0.1",
        port: int = DEFAULT_PORT,
        timeout: float = 10.0,
        state_transport: str = "json",
    ) -> None:
        if host not in LOOPBACK_HOSTS:
            raise BridgeError("research bridge only permits loopback hosts")
        self._host = host
        self._port = port
        self._timeout = timeout
        if state_transport not in {"json", "binary-v3"}:
            raise BridgeError(f"unsupported state transport: {state_transport!r}")
        self.state_transport = state_transport
        self._sock: Optional[socket.socket] = None
        self._reader: Optional[threading.Thread] = None
        self._stop = threading.Event()
        self._reader_error: Optional[str] = None
        self._send_lock = threading.Lock()
        self._states: "queue.Queue[dict[str, Any]]" = queue.Queue(maxsize=64)
        self._latest: Optional[dict[str, Any]] = None
        self._latest_lock = threading.Lock()
        self._events: "queue.Queue[dict[str, Any]]" = queue.Queue()
        self._deferred_events: deque[dict[str, Any]] = deque()
        self._request_lock = threading.Lock()
        self._next_request = 1
        self._char_names: dict[int, str] = {}
        self.match_generation = 0
        self.match_metadata: dict[str, Any] = {}
        self.hello: Optional[dict[str, Any]] = None

    # -- lifecycle ---------------------------------------------------------

    def connect(self) -> dict[str, Any]:
        if self._sock is not None:
            raise BridgeError("already connected")
        self._sock = socket.create_connection((self._host, self._port), self._timeout)
        self._sock.settimeout(None)
        self._stop.clear()
        self._reader_error = None
        # Read the hello handshake BEFORE starting the reader thread,
        # otherwise the thread races us and consumes it.
        hello = self._next_message(timeout=self._timeout)
        if hello is None or hello.get("type") != "hello":
            self.close()
            raise BridgeError(f"expected hello, got {hello!r}")
        self.hello = hello
        self._reader = threading.Thread(target=self._read_loop, daemon=True, name="ssf2-bridge-reader")
        self._reader.start()
        supported = set(hello.get("stateTransports", ["json"]))
        if self.state_transport not in supported:
            self.state_transport = "json"
        self.set_state_transport(self.state_transport, timeout=self._timeout)
        return hello

    def close(self) -> None:
        self._stop.set()
        if self._sock is not None:
            try:
                self._sock.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass
            try:
                self._sock.close()
            except OSError:
                pass
            self._sock = None
        if self._reader is not None:
            self._reader.join(timeout=2.0)
            self._reader = None

    def __enter__(self) -> "SSF2Bridge":
        self.connect()
        return self

    def __exit__(self, *_: object) -> None:
        self.close()

    # -- inbound -----------------------------------------------------------

    def _read_loop(self) -> None:
        assert self._sock is not None
        sock = self._sock
        buf = bytearray()
        while not self._stop.is_set():
            try:
                chunk = sock.recv(65536)
            except OSError:
                break
            if not chunk:
                break
            buf.extend(chunk)
            while buf:
                if buf.startswith(_BINARY_MAGIC):
                    if len(buf) < _BINARY_HEADER.size:
                        break
                    _, kind, schema, _, payload_length = _BINARY_HEADER.unpack_from(buf)
                    if schema != 3 or payload_length > _MAX_BINARY_PAYLOAD:
                        self._reader_error = "invalid binary state header"
                        self._events.put({"type": "protocol_error", "message": self._reader_error})
                        return
                    frame_length = _BINARY_HEADER.size + payload_length
                    if len(buf) < frame_length:
                        break
                    payload = bytes(buf[_BINARY_HEADER.size:frame_length])
                    del buf[:frame_length]
                    try:
                        self._dispatch_binary_state(kind, payload)
                    except (ValueError, struct.error) as exc:
                        self._reader_error = str(exc)
                        self._events.put({"type": "protocol_error", "message": self._reader_error})
                        return
                    continue
                if buf.startswith(_EPISODE_MAGIC):
                    if len(buf) < _EPISODE_HEADER.size:
                        break
                    _, generation, frame_count, payload_length = _EPISODE_HEADER.unpack_from(buf)
                    if payload_length > _MAX_EPISODE_PAYLOAD:
                        self._reader_error = "invalid episode header"
                        self._events.put({"type": "protocol_error", "message": self._reader_error})
                        return
                    frame_length = _EPISODE_HEADER.size + payload_length
                    if len(buf) < frame_length:
                        break
                    payload = bytes(buf[_EPISODE_HEADER.size:frame_length])
                    del buf[:frame_length]
                    try:
                        self._dispatch_episode(generation, frame_count, payload)
                    except (ValueError, struct.error) as exc:
                        self._reader_error = str(exc)
                        self._events.put({"type": "protocol_error", "message": self._reader_error})
                        return
                    continue
                newline = buf.find(b"\n")
                if newline < 0:
                    break
                line = bytes(buf[:newline])
                del buf[:newline + 1]
                if not line.strip():
                    continue
                try:
                    msg = json.loads(line.decode("utf-8"))
                except (UnicodeDecodeError, json.JSONDecodeError) as exc:
                    self._reader_error = str(exc)
                    self._events.put({"type": "protocol_error", "message": self._reader_error})
                    return
                self._dispatch(msg)
        if not self._stop.is_set() and self._reader_error is None:
            self._reader_error = "bridge disconnected"
        self._events.put({"type": "disconnected"})

    def _dispatch_binary_state(self, kind: int, payload: bytes) -> None:
        if len(payload) < _BINARY_PREFIX.size:
            raise ValueError("truncated binary state prefix")
        request, generation, frame, paused, ended, char_count, _ = _BINARY_PREFIX.unpack_from(payload)
        expected = _BINARY_PREFIX.size + char_count * _BINARY_CHAR.size
        if len(payload) != expected:
            raise ValueError(f"binary state length {len(payload)} != expected {expected}")
        chars = []
        offset = _BINARY_PREFIX.size
        for _ in range(char_count):
            (
                player_id, x, y, nxs, nys, facing, damage, stocks,
                ground, jump_count, shield_power, flags, atk_exec, controls,
            ) = _BINARY_CHAR.unpack_from(payload, offset)
            offset += _BINARY_CHAR.size
            chars.append({
                "id": player_id,
                "name": self._char_names.get(player_id, f"P{player_id}"),
                "x": x,
                "y": y,
                "nxs": nxs,
                "nys": nys,
                "facing": facing,
                "damage": damage,
                "stocks": stocks,
                "ground": ground,
                "jumpCount": jump_count,
                "shieldPower": shield_power,
                "shielding": 1 if flags & 1 else 0,
                "hitstun": 1 if flags & 2 else 0,
                "atkFrame": 1 if flags & 4 else 0,
                "atkExec": atk_exec,
                "hanging": 1 if flags & 8 else 0,
                "dead": 1 if flags & 16 else 0,
                "controls": controls,
            })
        self.match_generation = generation
        state = {
            "type": "state",
            "schema": 3,
            "frame": frame,
            "paused": paused,
            "ended": ended,
            "chars": chars,
        }
        if kind == 1:
            self._dispatch(state)
        elif kind == 2:
            self._dispatch({"type": "step_complete", "request": request, "state": state})
        else:
            raise ValueError(f"unknown binary state kind {kind}")

    def _dispatch_episode(self, generation: int, frame_count: int, payload: bytes) -> None:
        """Decode a bulk episode transfer and queue it as an event."""
        import zlib
        try:
            raw = zlib.decompress(payload)
        except zlib.error as exc:
            raise ValueError(f"episode decompression failed: {exc}")
        frames = []
        offset = 0
        for _ in range(frame_count):
            if offset + 7 > len(raw):
                raise ValueError("truncated episode frame header")
            frame, paused, ended, char_count = struct.unpack_from(">iBBB", raw, offset)
            offset += 7
            chars = []
            for _ in range(char_count):
                if offset + _BINARY_CHAR.size > len(raw):
                    raise ValueError("truncated episode character record")
                (
                    player_id, x, y, nxs, nys, facing, damage, stocks,
                    ground, jump_count, shield_power, flags, atk_exec, controls,
                ) = _BINARY_CHAR.unpack_from(raw, offset)
                offset += _BINARY_CHAR.size
                chars.append({
                    "id": player_id,
                    "name": self._char_names.get(player_id, f"P{player_id}"),
                    "x": x, "y": y, "nxs": nxs, "nys": nys,
                    "facing": facing, "damage": damage, "stocks": stocks,
                    "ground": ground, "jumpCount": jump_count,
                    "shieldPower": shield_power,
                    "shielding": 1 if flags & 1 else 0,
                    "hitstun": 1 if flags & 2 else 0,
                    "atkFrame": 1 if flags & 4 else 0,
                    "atkExec": atk_exec,
                    "hanging": 1 if flags & 8 else 0,
                    "dead": 1 if flags & 16 else 0,
                    "controls": controls,
                })
            frames.append({
                "frame": frame, "paused": paused, "ended": ended, "chars": chars,
            })
        self._events.put({
            "type": "episode",
            "generation": generation,
            "frames": frames,
        })

    def _dispatch(self, msg: dict[str, Any]) -> None:
        state = msg.get("state") if isinstance(msg.get("state"), dict) else msg
        if isinstance(state, dict):
            for char in state.get("chars", []):
                if "id" in char and char.get("name"):
                    self._char_names[int(char["id"])] = str(char["name"])
        if msg.get("generation") is not None:
            self.match_generation = int(msg["generation"])
        if isinstance(msg.get("metadata"), dict):
            self.match_metadata = msg["metadata"]
        mtype = msg.get("type")
        if mtype == "match_end":
            self.match_metadata = {}
            self._char_names.clear()
        if mtype == "state":
            with self._latest_lock:
                self._latest = msg
            try:
                self._states.put_nowait(msg)
            except queue.Full:
                try:
                    self._states.get_nowait()
                except queue.Empty:
                    pass
                try:
                    self._states.put_nowait(msg)
                except queue.Full:
                    pass
        else:
            self._events.put(msg)

    def _next_message(self, timeout: float) -> Optional[dict[str, Any]]:
        """Used before the reader thread starts (hello), via direct recv."""
        assert self._sock is not None
        self._sock.settimeout(timeout)
        buf = b""
        try:
            while b"\n" not in buf:
                chunk = self._sock.recv(4096)
                if not chunk:
                    return None
                buf += chunk
        finally:
            self._sock.settimeout(None)
        line = buf.split(b"\n", 1)[0]
        return json.loads(line.decode("utf-8"))

    # -- state access --------------------------------------------------------

    def latest_state(self) -> Optional[dict[str, Any]]:
        with self._latest_lock:
            return self._latest

    def wait_state(self, timeout: float = 5.0, min_frame: Optional[int] = None) -> dict[str, Any]:
        """Block until a state snapshot (optionally with frame >= min_frame)."""
        import time

        deadline = time.monotonic() + timeout
        while True:
            if self._reader_error is not None:
                raise BridgeError(self._reader_error)
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise BridgeError("timed out waiting for state")
            try:
                state = self._states.get(timeout=min(remaining, 0.25))
            except queue.Empty:
                continue
            if min_frame is None or state.get("frame", 0) >= min_frame:
                return state

    def drain_events(self) -> list[dict[str, Any]]:
        out = list(self._deferred_events)
        self._deferred_events.clear()
        while True:
            try:
                out.append(self._events.get_nowait())
            except queue.Empty:
                return out

    def clear_pending_messages(self) -> None:
        """Discard state/event traffic from a previous match before reset."""
        while True:
            try:
                self._states.get_nowait()
            except queue.Empty:
                break
        self.drain_events()

    def wait_reply(
        self,
        request: int,
        expected_type: str,
        timeout: float = 5.0,
    ) -> dict[str, Any]:
        """Wait for the reply matching a lockstep command request id.

        Unrelated events are retained for later consumers; an error response
        for this request and a transport disconnect fail immediately.
        """
        deadline = time.monotonic() + timeout
        while True:
            for event in list(self._deferred_events):
                if event.get("type") == "disconnected":
                    self._deferred_events.remove(event)
                    raise BridgeError("bridge disconnected while waiting for reply")
                if event.get("type") == "protocol_error":
                    self._deferred_events.remove(event)
                    raise BridgeError(event.get("message", "bridge protocol error"))
                if event.get("request") != request:
                    continue
                self._deferred_events.remove(event)
                if event.get("type") == "error":
                    raise BridgeError(event.get("message", "game rejected command"))
                if event.get("type") == expected_type:
                    return event
                raise BridgeError(
                    f"expected {expected_type!r} for request {request}, "
                    f"got {event.get('type')!r}"
                )

            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise BridgeError(
                    f"timed out waiting for {expected_type!r} reply to request {request}"
                )
            try:
                event = self._events.get(timeout=min(remaining, 0.25))
            except queue.Empty:
                continue
            self._deferred_events.append(event)

    def wait_episode(self, timeout: float = 30.0) -> dict[str, Any]:
        """Wait for a bulk episode transfer (triggered by get_episode)."""
        deadline = time.monotonic() + timeout
        while True:
            for event in list(self._deferred_events):
                if event.get("type") == "disconnected":
                    self._deferred_events.remove(event)
                    raise BridgeError("bridge disconnected while waiting for episode")
                if event.get("type") == "protocol_error":
                    self._deferred_events.remove(event)
                    raise BridgeError(event.get("message", "bridge protocol error"))
                if event.get("type") == "episode":
                    self._deferred_events.remove(event)
                    return event
                # Skip non-episode events (e.g. episode_ready ack)
                self._deferred_events.remove(event)

            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise BridgeError("timed out waiting for episode")
            try:
                event = self._events.get(timeout=min(remaining, 0.25))
            except queue.Empty:
                continue
            self._deferred_events.append(event)

    # -- outbound ------------------------------------------------------------

    def _send(self, msg: dict[str, Any]) -> None:
        if self._sock is None:
            raise BridgeError("not connected")
        data = (json.dumps(msg, separators=(",", ":")) + "\n").encode("utf-8")
        with self._send_lock:
            self._sock.sendall(data)

    def _send_request(self, command: str) -> int:
        with self._request_lock:
            request = self._next_request
            self._next_request += 1
        self._send({"type": command, "request": request})
        return request

    def send_input(self, player: int, bits: int) -> None:
        """Hold an input mask on a CPU-controlled slot until it is replaced."""
        if not isinstance(bits, int) or bits < 0 or bits >> 22:
            raise BridgeError(f"invalid controls mask: {bits!r}")
        self._send({"type": "input", "player": int(player), "bits": bits})

    def takeover(self, player: int) -> None:
        """Convert a player slot to CPU control so the bridge can drive it."""
        self._send({"type": "takeover", "player": int(player)})

    def set_overlay(self, player: int) -> None:
        """Show held controls for a player slot in-game (0 hides the overlay)."""
        if not isinstance(player, int) or player < 0:
            raise BridgeError(f"invalid overlay player: {player!r}")
        self._send({"type": "overlay", "player": player})

    def start_recording(self) -> int:
        """Begin buffering frames game-side; use ``wait_reply(request, "ack")``."""
        return self._send_request("start_recording")

    def stop_recording(self) -> int:
        """Stop buffering; use ``wait_reply(request, "ack")``."""
        return self._send_request("stop_recording")

    def get_episode(self) -> int:
        """Request the buffered episode; use ``wait_reply(request, "episode")``."""
        return self._send_request("get_episode")

    def load_replay(self, replay_json: dict) -> int:
        """Load a replay from parsed JSON; use ``wait_reply(request, "ack")``."""
        with self._request_lock:
            request = self._next_request
            self._next_request += 1
        self._send({"type": "load_replay", "request": request, "replay": replay_json})
        return request

    def ping(self) -> None:
        self._send({"type": "ping"})

    def request_state(self) -> None:
        self._send({"type": "state"})

    def request_full_state(self, timeout: float = 5.0) -> dict[str, Any]:
        """Request the full debug snapshot; this is not part of the hot path."""
        request = self._send_request("state_full")
        reply = self.wait_reply(request, "full_state", timeout=timeout)
        state = reply.get("state")
        if not isinstance(state, dict):
            raise BridgeError("full_state reply did not include a state")
        return state

    def configure_transport(self, transport: str) -> int:
        with self._request_lock:
            request = self._next_request
            self._next_request += 1
        self._send({"type": "configure_transport", "request": request, "transport": transport})
        return request

    def set_state_transport(self, transport: str, timeout: float = 5.0) -> None:
        """Negotiate a state transport and wait until the game accepts it."""
        if transport not in {"json", "binary-v3"}:
            raise BridgeError(f"unsupported state transport: {transport!r}")
        request = self.configure_transport(transport)
        self.wait_reply(request, "ack", timeout=timeout)
        self.state_transport = transport

    def restart_match(self, config: dict | None = None) -> int:
        """Start a fresh match and return its request id."""
        with self._request_lock:
            request = self._next_request
            self._next_request += 1
        msg: dict = {"type": "restart_match", "request": request}
        if config is not None:
            msg["config"] = config
        self._send(msg)
        return request

    def pause(self) -> int:
        """Request a lockstep pause; use ``wait_reply(request, "ack")``."""
        return self._send_request("pause")

    def step_frame(self) -> int:
        """Request one lockstep frame; use ``wait_reply(request, "step_complete")``."""
        return self._send_request("step")

    def step_frame_sync(self) -> int:
        """Immediately pump one lockstep frame without waiting for AIR rendering."""
        return self._send_request("step_sync")

    def resume(self) -> int:
        """Leave lockstep mode; use ``wait_reply(request, "ack")``."""
        return self._send_request("resume")
