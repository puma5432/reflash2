"""macOS launcher for the instrumented SSF2 AIR payload."""
from __future__ import annotations
import os, socket, subprocess, threading, time
from pathlib import Path
from typing import Optional

DEFAULT_PORT = 4567
_REPO_ROOT = Path(__file__).resolve().parents[3]
_lock = threading.Lock(); _spawned: Optional[subprocess.Popen] = None; _log_path: Optional[Path] = None

class LaunchError(RuntimeError): pass

def repo_root() -> Path: return _REPO_ROOT

def port_open(host: str = "127.0.0.1", port: int = DEFAULT_PORT, timeout: float = .5) -> bool:
    try:
        with socket.create_connection((host, port), timeout): return True
    except OSError: return False

def _resolve_air_sdk(air_sdk_home: Optional[str]) -> Path:
    candidates = ([air_sdk_home] if air_sdk_home else []) + ([os.environ["AIR_SDK_HOME"]] if os.environ.get("AIR_SDK_HOME") else [])
    for candidate in candidates:
        if (Path(candidate).expanduser() / "bin" / "adl").exists(): return Path(candidate).expanduser()
    for candidate in sorted((Path.home() / "Developer").glob("AIRSDK*"), key=lambda path: path.name, reverse=True):
        if (candidate / "bin" / "adl").exists(): return candidate
    raise LaunchError("No AIR SDK found. Install Harman AIR and set AIR_SDK_HOME.")

def _resolve_payload() -> Path:
    payload = _REPO_ROOT / ".macos" / "payload"; app_xml = payload / "META-INF" / "AIR" / "application.xml"
    if app_xml.exists(): return payload
    prep = _REPO_ROOT / "tools" / "macos" / "prepare_macos_launch_payload.sh"
    if not prep.exists(): raise LaunchError(f"Launch payload not found at {payload} and preparation script is missing ({prep}).")
    proc = subprocess.run(["bash", str(prep)], cwd=_REPO_ROOT, capture_output=True, text=True)
    if proc.returncode or not app_xml.exists(): raise LaunchError(f"Payload preparation failed (exit {proc.returncode}).\n{(proc.stderr or proc.stdout or '').strip()[-2000:]}")
    return payload

def ensure_game_running(host: str = "127.0.0.1", port: int = DEFAULT_PORT, timeout: float = 90., air_sdk_home: Optional[str] = None, verbose: bool = True) -> bool:
    global _spawned, _log_path
    if port_open(host, port): return True
    with _lock:
        if port_open(host, port): return True
        if _spawned is not None and _spawned.poll() is not None: _spawned = None
        sdk, payload = _resolve_air_sdk(air_sdk_home), _resolve_payload(); app_xml = payload / "META-INF" / "AIR" / "application.xml"
        log_dir = _REPO_ROOT / ".macos"; log_dir.mkdir(exist_ok=True); _log_path = log_dir / "adl.log"
        if verbose: print(f"[ssf2_rl] Launching SSF2 via {sdk / 'bin' / 'adl'} (log: {_log_path}) ...")
        with open(_log_path, "ab") as log: _spawned = subprocess.Popen([str(sdk / "bin" / "adl"), str(app_xml), str(payload)], cwd=payload, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if port_open(host, port): return False
        if _spawned is not None and _spawned.poll() is not None: raise LaunchError(f"Game process exited early (code {_spawned.returncode}). See {_log_path}.")
        time.sleep(.5)
    raise LaunchError(f"Timed out after {timeout:.0f}s waiting for the bridge on {host}:{port}. See {_log_path}.")

def stop_game() -> None:
    global _spawned
    with _lock:
        if _spawned is None: return
        if _spawned.poll() is None:
            _spawned.terminate()
            try: _spawned.wait(timeout=5)
            except subprocess.TimeoutExpired: _spawned.kill()
        _spawned = None

def game_log_path() -> Optional[Path]: return _log_path
