#!/usr/bin/env python3
"""Wait for the SSF2 RL bridge to come online and print the handshake + first state.

Run this in one terminal, then start a match in the game.
"""
from __future__ import annotations

import socket
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "python"))

from ssf2_rl import SSF2Bridge  # noqa: E402

HOST, PORT = "127.0.0.1", 4567


def port_open() -> bool:
    try:
        with socket.create_connection((HOST, PORT), 0.5):
            return True
    except OSError:
        return False


def main() -> int:
    print(f"Waiting for bridge on {HOST}:{PORT} (start a match in the game)...")
    deadline = time.monotonic() + 300
    while time.monotonic() < deadline:
        if port_open():
            break
        time.sleep(1.0)
    else:
        print("Timed out waiting for the bridge port.")
        return 1

    print("Port is open. Connecting...")
    bridge = SSF2Bridge(HOST, PORT, timeout=15.0)
    hello = bridge.connect()
    print(f"Handshake: {hello}")
    try:
        state = bridge.wait_state(timeout=10.0)
        print(f"State @ frame {state['frame']} (paused={state['paused']}, ended={state['ended']}):")
        for ch in state["chars"]:
            print(
                f"  P{ch['id']} {ch.get('name','?'):<12} pos=({ch['x']:.1f},{ch['y']:.1f}) "
                f"vel=({ch['xs']:.2f},{ch['ys']:.2f}) dmg={ch['damage']:.0f} "
                f"lives={ch['lives']} state={ch['state']} cpu={ch['cpu']} ground={ch['ground']}"
            )
        # Stream check
        t0, n, last = time.monotonic(), 0, state["frame"]
        while time.monotonic() - t0 < 3.0:
            s = bridge.wait_state(timeout=2.0, min_frame=last + 1)
            n += 1
            last = s["frame"]
        print(f"OK: streamed {n} frames in ~3s, latest frame {last}.")
        return 0
    finally:
        bridge.close()


if __name__ == "__main__":
    raise SystemExit(main())
