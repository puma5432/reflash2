"""Auto-launch the instrumented SSF2 build so ``env.reset()`` just works.

``ensure_game_running()`` is idempotent: if the research bridge port is
already listening it returns immediately; otherwise it spawns the macOS
``adl`` payload (the same invocation as ``tools/macos/run_macos.sh``) and
polls until the bridge comes online. The spawned process is detached so the
game survives notebook kernel restarts; use ``stop_game()`` to tear it down.

Only processes spawned by THIS module are ever killed — a game you started
manually in a terminal is left alone.
"""

from __future__ import annotations

import os
import socket
import subprocess
import threading
import time
from pathlib import Path
from typing import Optional

DEFAULT_PORT = 4567

# Repo root: .../reflash2/python/ssf2_rl/launcher.py -> parents[2]
_REPO_ROOT = Path(__file__).resolve().parents[2]

_lock = threading.Lock()
_spawned: Optional[subprocess.Popen] = None  # only processes WE started
_log_path: Optional[Path] = None


class LaunchError(RuntimeError):
    """Raised when the game cannot be started or the bridge never opens."""


def repo_root() -> Path:
    return _REPO_ROOT


def port_open(host: str = "127.0.0.1", port: int = DEFAULT_PORT, timeout: float = 0.5) -> bool:
    """True if something is listening on the bridge port."""
    try:
        with socket.create_connection((host, port), timeout):
            return True
    except OSError:
        return False


def _resolve_air_sdk(air_sdk_home: Optional[str]) -> Path:
    """Explicit arg > $AIR_SDK_HOME > ~/Developer/AIRSDK* (newest)."""
    candidates: list[str] = []
    if air_sdk_home:
        candidates.append(air_sdk_home)
    if os.environ.get("AIR_SDK_HOME"):
        candidates.append(os.environ["AIR_SDK_HOME"])
    for c in candidates:
        adl = Path(c).expanduser() / "bin" / "adl"
        if adl.exists():
            return Path(c).expanduser()
    # Fallback: glob common location, pick the newest-looking SDK.
    dev = Path.home() / "Developer"
    if dev.is_dir():
        found = sorted(dev.glob("AIRSDK*"), key=lambda p: p.name, reverse=True)
        for sdk in found:
            if (sdk / "bin" / "adl").exists():
                return sdk
    raise LaunchError(
        "No AIR SDK found. Install Harman AIR and set AIR_SDK_HOME, e.g.\n"
        "  export AIR_SDK_HOME=\"$HOME/Developer/AIRSDK_51.3.3\""
    )


def _resolve_payload() -> Path:
    """Return the macOS launch payload dir, preparing it if necessary."""
    payload = _REPO_ROOT / ".macos" / "payload"
    app_xml = payload / "META-INF" / "AIR" / "application.xml"
    if app_xml.exists():
        return payload
    # Payload missing: try to build it with the repo's prep script.
    prep = _REPO_ROOT / "tools" / "macos" / "prepare_macos_launch_payload.sh"
    if not prep.exists():
        raise LaunchError(
            f"Launch payload not found at {payload} and the prep script is "
            f"missing too ({prep})."
        )
    print(f"[ssf2_rl] Preparing macOS launch payload: {prep.name} ...")
    proc = subprocess.run(["bash", str(prep)], cwd=_REPO_ROOT,
                          capture_output=True, text=True)
    if proc.returncode != 0 or not app_xml.exists():
        raise LaunchError(
            f"Payload preparation failed (exit {proc.returncode}).\n"
            f"Run manually: bash {prep}\n"
            f"{(proc.stderr or proc.stdout or '').strip()[-2000:]}"
        )
    return payload


def ensure_game_running(
    host: str = "127.0.0.1",
    port: int = DEFAULT_PORT,
    timeout: float = 90.0,
    air_sdk_home: Optional[str] = None,
    verbose: bool = True,
) -> bool:
    """Make sure the instrumented game is up and its bridge port is listening.

    Returns True if the game was already running, False if this call spawned
    it. Raises ``LaunchError`` if the game cannot be started.
    """
    global _spawned, _log_path

    if port_open(host, port):
        return True

    with _lock:
        # Re-check inside the lock (another thread may have launched it).
        if port_open(host, port):
            return True
        # If we previously spawned a game that died, drop the stale handle.
        if _spawned is not None and _spawned.poll() is not None:
            _spawned = None

        sdk = _resolve_air_sdk(air_sdk_home)
        payload = _resolve_payload()
        adl = sdk / "bin" / "adl"
        app_xml = payload / "META-INF" / "AIR" / "application.xml"

        log_dir = _REPO_ROOT / ".macos"
        log_dir.mkdir(exist_ok=True)
        _log_path = log_dir / "adl.log"

        if verbose:
            print(f"[ssf2_rl] Launching SSF2 via {adl} (log: {_log_path}) ...")
        with open(_log_path, "ab") as log:
            _spawned = subprocess.Popen(
                [str(adl), str(app_xml), str(payload)],
                cwd=str(payload),
                stdout=log,
                stderr=subprocess.STDOUT,
                start_new_session=True,  # survive kernel/parent exit
            )

    # Poll for the bridge port (the game opens it once the match auto-starts).
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if port_open(host, port):
            if verbose:
                print(f"[ssf2_rl] Game is up; bridge listening on {host}:{port}.")
            return False
        if _spawned is not None and _spawned.poll() is not None:
            raise LaunchError(
                f"Game process exited early (code {_spawned.returncode}). "
                f"See {_log_path}:\n{_tail(_log_path)}"
            )
        time.sleep(0.5)

    raise LaunchError(
        f"Timed out after {timeout:.0f}s waiting for the bridge on "
        f"{host}:{port}. See {_log_path}:\n{_tail(_log_path)}"
    )


def stop_game() -> None:
    """Terminate the game ONLY if this module spawned it."""
    global _spawned
    with _lock:
        if _spawned is None:
            return
        if _spawned.poll() is None:
            _spawned.terminate()
            try:
                _spawned.wait(timeout=5.0)
            except subprocess.TimeoutExpired:
                _spawned.kill()
        _spawned = None


def game_log_path() -> Optional[Path]:
    """Path of the adl output log (None if we never launched the game)."""
    return _log_path


def _tail(path: Optional[Path], lines: int = 20) -> str:
    if path is None or not path.exists():
        return "(no log)"
    try:
        text = path.read_text(errors="replace").splitlines()
        return "\n".join(text[-lines:])
    except OSError:
        return "(log unreadable)"
