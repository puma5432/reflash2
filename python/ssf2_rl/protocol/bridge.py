"""Loopback TCP client for the SSF2 research bridge."""

from __future__ import annotations
import json
import queue
import socket
import threading
import time
from collections import deque
from typing import Any, Optional
from .binary import BINARY_HEADER, BINARY_MAGIC, EPISODE_HEADER, EPISODE_MAGIC, MAX_BINARY_PAYLOAD, MAX_EPISODE_PAYLOAD, decode_binary_state, decode_episode

LOOPBACK_HOSTS = frozenset({"127.0.0.1", "::1", "localhost"})
DEFAULT_PORT = 4567


class BridgeError(RuntimeError):
    """Raised for protocol and connection violations."""


class SSF2Bridge:
    """Synchronous bridge client with a background socket reader."""
    def __init__(self, host: str = "127.0.0.1", port: int = DEFAULT_PORT, timeout: float = 10.0, state_transport: str = "json") -> None:
        if host not in LOOPBACK_HOSTS:
            raise BridgeError("research bridge only permits loopback hosts")
        if state_transport not in {"json", "binary-v3"}:
            raise BridgeError(f"unsupported state transport: {state_transport!r}")
        self._host, self._port, self._timeout, self.state_transport = host, port, timeout, state_transport
        self._sock: Optional[socket.socket] = None;
        self._reader: Optional[threading.Thread] = None
        self._stop = threading.Event();
        self._reader_error: Optional[str] = None;
        self._send_lock = threading.Lock()
        self._states: queue.Queue[dict[str, Any]] = queue.Queue(maxsize=64);
        self._latest: Optional[dict[str, Any]] = None
        self._latest_lock = threading.Lock();
        self._events: queue.Queue[dict[str, Any]] = queue.Queue();
        self._deferred_events: deque[dict[str, Any]] = deque()
        self._request_lock = threading.Lock();
        self._next_request = 1;
        self._char_names: dict[int, str] = {}
        self.match_generation = 0;
        self.match_metadata: dict[str, Any] = {};
        self.hello: Optional[dict[str, Any]] = None

    def connect(self) -> dict[str, Any]:
        if self._sock is not None:
            raise BridgeError("already connected")
        self._sock = socket.create_connection((self._host, self._port), self._timeout);
        self._sock.settimeout(None);
        self._stop.clear();
        self._reader_error = None

        hello = self._next_message(self._timeout)
        if hello is None or hello.get("type") != "hello":
            self.close();
            raise BridgeError(f"expected hello, got {hello!r}")
        self.hello = hello;
        self._reader = threading.Thread(target=self._read_loop, daemon=True, name="ssf2-bridge-reader");
        self._reader.start()
        if self.state_transport not in set(hello.get("stateTransports", ["json"])):
            self.state_transport = "json"
        self.set_state_transport(self.state_transport, timeout=self._timeout)
        return hello

    def close(self) -> None:
        self._stop.set()
        if self._sock:
            try:
                self._sock.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass
            try:
                self._sock.close()
            except OSError:
                pass
            self._sock = None
        if self._reader:
            self._reader.join(timeout=2);
            self._reader = None

    def __enter__(self) -> "SSF2Bridge":
        self.connect();
        return self

    def __exit__(self, *_: object) -> None:
        self.close()

    def _read_loop(self) -> None:
        assert self._sock is not None
        buffer = bytearray()
        while not self._stop.is_set():
            try: chunk = self._sock.recv(65536)
            except OSError: break
            if not chunk: break
            buffer.extend(chunk)
            while buffer:
                if buffer.startswith(BINARY_MAGIC):
                    if len(buffer) < BINARY_HEADER.size:
                        break
                    _, kind, schema, _, length = BINARY_HEADER.unpack_from(buffer)
                    if schema != 3 or length > MAX_BINARY_PAYLOAD:
                        return self._protocol_error("invalid binary state header")
                    if len(buffer) < BINARY_HEADER.size + length:
                        break
                    payload = bytes(buffer[BINARY_HEADER.size:BINARY_HEADER.size + length]);
                    del buffer[:BINARY_HEADER.size + length]
                    try:
                        event, generation = decode_binary_state(kind, payload, self._char_names);
                        self.match_generation = generation; self._dispatch(event)
                    except ValueError as exc:
                        return self._protocol_error(str(exc))
                    continue
                if buffer.startswith(EPISODE_MAGIC):
                    if len(buffer) < EPISODE_HEADER.size:
                        break
                    _, generation, count, length = EPISODE_HEADER.unpack_from(buffer)
                    if length > MAX_EPISODE_PAYLOAD:
                        return self._protocol_error("invalid episode header")
                    if len(buffer) < EPISODE_HEADER.size + length:
                        break
                    payload = bytes(buffer[EPISODE_HEADER.size:EPISODE_HEADER.size + length]);
                    del buffer[:EPISODE_HEADER.size + length]
                    try:
                        self._events.put(decode_episode(generation, count, payload, self._char_names))
                    except ValueError as exc:
                        return self._protocol_error(str(exc))
                    continue
                newline = buffer.find(b"\n")
                if newline < 0:
                    break
                line = bytes(buffer[:newline]);
                del buffer[:newline + 1]
                if not line.strip():
                    continue
                try:
                    self._dispatch(json.loads(line.decode("utf-8")))
                except (UnicodeDecodeError, json.JSONDecodeError) as exc:
                    return self._protocol_error(str(exc))
        if not self._stop.is_set() and self._reader_error is None:
            self._reader_error = "bridge disconnected"
        self._events.put({"type": "disconnected"})

    def _protocol_error(self, message: str) -> None:
        self._reader_error = message;
        self._events.put({"type": "protocol_error", "message": message})

    def _dispatch(self, message: dict[str, Any]) -> None:
        state = message.get("state") if isinstance(message.get("state"), dict) else message
        if isinstance(state, dict):
            for character in state.get("chars", []):
                if "id" in character and character.get("name"):
                    self._char_names[int(character["id"])] = str(character["name"])
        if message.get("generation") is not None:
            self.match_generation = int(message["generation"])
        if isinstance(message.get("metadata"), dict):
            self.match_metadata = message["metadata"]
        if message.get("type") == "match_end":
            self.match_metadata = {};
            self._char_names.clear()
        if message.get("type") == "state":
            with self._latest_lock:
                self._latest = message
            try:
                self._states.put_nowait(message)
            except queue.Full:
                try:
                    self._states.get_nowait();
                    self._states.put_nowait(message)
                except queue.Empty:
                    pass
        else:
            self._events.put(message)

    def _next_message(self, timeout: float) -> Optional[dict[str, Any]]:
        assert self._sock is not None;
        self._sock.settimeout(timeout);
        buffer = b""
        try:
            while b"\n" not in buffer:
                chunk = self._sock.recv(4096)
                if not chunk:
                    return None
                buffer += chunk
        finally:
            self._sock.settimeout(None)
        return json.loads(buffer.split(b"\n", 1)[0].decode("utf-8"))

    def latest_state(self) -> Optional[dict[str, Any]]:
        with self._latest_lock:
            return self._latest

    def wait_state(self, timeout: float = 5.0, min_frame: Optional[int] = None) -> dict[str, Any]:
        deadline = time.monotonic() + timeout
        while True:
            if self._reader_error:
                raise BridgeError(self._reader_error)
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise BridgeError("timed out waiting for state")
            try:
                state = self._states.get(timeout=min(remaining, .25))
            except queue.Empty:
                continue
            if min_frame is None or state.get("frame", 0) >= min_frame:
                return state

    def drain_events(self) -> list[dict[str, Any]]:
        events = list(self._deferred_events); self._deferred_events.clear()
        while True:
            try:
                events.append(self._events.get_nowait())
            except queue.Empty:
                return events

    def clear_pending_messages(self) -> None:
        while True:
            try:
                self._states.get_nowait()
            except queue.Empty:
                break
        self.drain_events()

    def wait_reply(self, request: int, expected_type: str, timeout: float = 5.0) -> dict[str, Any]:
        deadline = time.monotonic() + timeout
        while True:
            for event in list(self._deferred_events):
                if event.get("type") in {"disconnected", "protocol_error"}:
                    self._deferred_events.remove(event); raise BridgeError(event.get("message", "bridge disconnected while waiting for reply"))
                if event.get("request") != request:
                    continue
                self._deferred_events.remove(event)
                if event.get("type") == "error":
                    raise BridgeError(event.get("message", "game rejected command"))
                if event.get("type") == expected_type:
                    return event
                raise BridgeError(f"expected {expected_type!r} for request {request}, got {event.get('type')!r}")
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise BridgeError(f"timed out waiting for {expected_type!r} reply to request {request}")
            try:
                self._deferred_events.append(self._events.get(timeout=min(remaining, .25)))
            except queue.Empty:
                continue

    def wait_episode(self, timeout: float = 30.0) -> dict[str, Any]:
        deadline = time.monotonic() + timeout
        while True:
            for event in list(self._deferred_events):
                self._deferred_events.remove(event)
                if event.get("type") == "episode":
                    return event
                if event.get("type") in {"disconnected", "protocol_error"}:
                    raise BridgeError(event.get("message", "bridge disconnected while waiting for episode"))
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise BridgeError("timed out waiting for episode")
            try:
                self._deferred_events.append(self._events.get(timeout=min(remaining, .25)))
            except queue.Empty:
                continue

    def _send(self, message: dict[str, Any]) -> None:
        if self._sock is None:
             raise BridgeError("not connected")
        with self._send_lock:
             self._sock.sendall((json.dumps(message, separators=(",", ":")) + "\n").encode())

    def _send_request(self, command: str) -> int:
        with self._request_lock:
            request = self._next_request; self._next_request += 1
        self._send({"type": command, "request": request});
        return request

    def send_input(self, player: int, bits: int) -> None:
        if not isinstance(bits, int) or bits < 0 or bits >> 22: raise BridgeError(f"invalid controls mask: {bits!r}")
        self._send({"type": "input", "player": int(player), "bits": bits})
    def takeover(self, player: int) -> None: self._send({"type": "takeover", "player": int(player)})
    def set_overlay(self, player: int) -> None:
        if not isinstance(player, int) or player < 0: raise BridgeError(f"invalid overlay player: {player!r}")
        self._send({"type": "overlay", "player": player})
    def start_recording(self) -> int: return self._send_request("start_recording")
    def stop_recording(self) -> int: return self._send_request("stop_recording")
    def get_episode(self) -> int: return self._send_request("get_episode")
    def ping(self) -> None: self._send({"type": "ping"})
    def request_state(self) -> None: self._send({"type": "state"})
    def pause(self) -> int: return self._send_request("pause")
    def step_frame(self) -> int: return self._send_request("step")
    def step_frame_sync(self) -> int: return self._send_request("step_sync")
    def resume(self) -> int: return self._send_request("resume")
    def fast_replay_batch(self, max_frames: int) -> int:
        """Advance a paused native replay and wait for `fast_replay_complete`."""
        if not isinstance(max_frames, int) or isinstance(max_frames, bool) or not 0 < max_frames <= 4096:
            raise BridgeError("max_frames must be an integer from 1 through 4096")
        with self._request_lock:
            request = self._next_request; self._next_request += 1
        self._send({"type": "fast_replay_batch", "request": request, "max_frames": max_frames})
        return request
    def load_replay(self, replay_json: dict, pause_on_start: bool = False) -> int:
        with self._request_lock: request = self._next_request; self._next_request += 1
        message = {"type": "load_replay", "request": request, "replay": replay_json}
        if pause_on_start:
            message["pause_on_start"] = True
        self._send(message)
        return request

    def request_full_state(self, timeout: float = 5.0) -> dict[str, Any]:
        request = self._send_request("state_full")
        reply = self.wait_reply(request, "full_state", timeout)
        state = reply.get("state")
        if not isinstance(state, dict): raise BridgeError("full_state reply did not include a state")
        return state

    def configure_transport(self, transport: str) -> int:
        with self._request_lock: request = self._next_request; self._next_request += 1
        self._send({"type": "configure_transport", "request": request, "transport": transport})
        return request

    def set_state_transport(self, transport: str, timeout: float = 5.0) -> None:
        if transport not in {"json", "binary-v3"}: raise BridgeError(f"unsupported state transport: {transport!r}")
        self.wait_reply(self.configure_transport(transport), "ack", timeout)
        self.state_transport = transport

    def restart_match(self, config: dict | None = None) -> int:
        with self._request_lock: request = self._next_request; self._next_request += 1
        message: dict[str, Any] = {"type": "restart_match", "request": request}
        if config is not None: message["config"] = config
        self._send(message)
        return request
