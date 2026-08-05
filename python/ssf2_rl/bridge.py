"""Loopback TCP client for the SSF2 research bridge.

Wire protocol (newline-delimited JSON, matches tools/rl/ModAPI_patched.as):

  game -> client:
    {"type":"hello","api":...,"port":...,"framerate":...}
    {"type":"state","frame":N,"paused":0|1,"ended":0|1,"chars":[...]}
    {"type":"match_end"}   (ModAPI.deinit - match torn down)
    {"type":"game_ended"}  (match reached an end condition)

  client -> game:
    {"type":"input","player":P,"bits":M}    one frame of held input
    {"type":"takeover","player":P}          convert slot P to CPU control
    {"type":"ping"}                          -> {"type":"pong"}
    {"type":"state"}                         -> immediate extra snapshot

Only loopback endpoints are permitted.
"""

from __future__ import annotations

import json
import queue
import socket
import threading
from typing import Any, Optional

LOOPBACK_HOSTS = frozenset({"127.0.0.1", "::1", "localhost"})
DEFAULT_PORT = 4567


class BridgeError(RuntimeError):
    """Raised for protocol/connection violations."""


class SSF2Bridge:
    """Synchronous client with a background reader thread.

    States are buffered in a bounded queue; ``latest_state`` always returns the
    most recent snapshot, discarding stale ones (the game streams at 30 FPS).
    """

    def __init__(self, host: str = "127.0.0.1", port: int = DEFAULT_PORT, timeout: float = 10.0) -> None:
        if host not in LOOPBACK_HOSTS:
            raise BridgeError("research bridge only permits loopback hosts")
        self._host = host
        self._port = port
        self._timeout = timeout
        self._sock: Optional[socket.socket] = None
        self._reader: Optional[threading.Thread] = None
        self._stop = threading.Event()
        self._send_lock = threading.Lock()
        self._states: "queue.Queue[dict[str, Any]]" = queue.Queue(maxsize=64)
        self._latest: Optional[dict[str, Any]] = None
        self._latest_lock = threading.Lock()
        self._events: "queue.Queue[dict[str, Any]]" = queue.Queue()
        self.hello: Optional[dict[str, Any]] = None

    # -- lifecycle ---------------------------------------------------------

    def connect(self) -> dict[str, Any]:
        if self._sock is not None:
            raise BridgeError("already connected")
        self._sock = socket.create_connection((self._host, self._port), self._timeout)
        self._sock.settimeout(None)
        self._stop.clear()
        # Read the hello handshake BEFORE starting the reader thread,
        # otherwise the thread races us and consumes it.
        hello = self._next_message(timeout=self._timeout)
        if hello is None or hello.get("type") != "hello":
            self.close()
            raise BridgeError(f"expected hello, got {hello!r}")
        self.hello = hello
        self._reader = threading.Thread(target=self._read_loop, daemon=True, name="ssf2-bridge-reader")
        self._reader.start()
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
        buf = b""
        while not self._stop.is_set():
            try:
                chunk = self._sock.recv(65536)
            except OSError:
                break
            if not chunk:
                break
            buf += chunk
            while b"\n" in buf:
                line, buf = buf.split(b"\n", 1)
                if not line.strip():
                    continue
                try:
                    msg = json.loads(line.decode("utf-8"))
                except (UnicodeDecodeError, json.JSONDecodeError):
                    continue
                self._dispatch(msg)
        self._events.put({"type": "disconnected"})

    def _dispatch(self, msg: dict[str, Any]) -> None:
        mtype = msg.get("type")
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
        out: list[dict[str, Any]] = []
        while True:
            try:
                out.append(self._events.get_nowait())
            except queue.Empty:
                return out

    # -- outbound ------------------------------------------------------------

    def _send(self, msg: dict[str, Any]) -> None:
        if self._sock is None:
            raise BridgeError("not connected")
        data = (json.dumps(msg, separators=(",", ":")) + "\n").encode("utf-8")
        with self._send_lock:
            self._sock.sendall(data)

    def send_input(self, player: int, bits: int) -> None:
        """Queue one frame of held input for a CPU-controlled player slot."""
        if not isinstance(bits, int) or bits < 0 or bits >> 22:
            raise BridgeError(f"invalid controls mask: {bits!r}")
        self._send({"type": "input", "player": int(player), "bits": bits})

    def takeover(self, player: int) -> None:
        """Convert a player slot to CPU control so the bridge can drive it."""
        self._send({"type": "takeover", "player": int(player)})

    def ping(self) -> None:
        self._send({"type": "ping"})

    def request_state(self) -> None:
        self._send({"type": "state"})

    def restart_match(self, config: dict | None = None) -> None:
        """Tear down the current match and start a fresh one (for env.reset())."""
        msg: dict = {"type": "restart_match"}
        if config is not None:
            msg["config"] = config
        self._send(msg)
