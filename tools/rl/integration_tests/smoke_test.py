#!/usr/bin/env python3
"""Smoke test for the SSF2 RL bridge.

Usage:
  1. Launch the research build:
       AIR_SDK_HOME=~/Developer/AIRSDK_51.3.3 bash tools/macos/run_macos.sh
  2. Start a local VS match (any characters, CPU opponent is fine).
  3. Run this script:
    python3 tools/rl/integration_tests/smoke_test.py

It connects to the bridge, prints the handshake and a few state snapshots,
takes over player slot 2 (if human) and wiggles the controlled character
with a fixed input sequence.
"""

from __future__ import annotations

import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "python"))

from ssf2_rl import SSF2Bridge, Controls, describe_mask  # noqa: E402

PORT = 4567
HOST = "127.0.0.1"


def main() -> int:
    print(f"Connecting to {HOST}:{PORT} ...")
    try:
        bridge = SSF2Bridge(HOST, PORT, timeout=15.0)
        hello = bridge.connect()
    except Exception as exc:  # noqa: BLE001
        print(f"FAILED to connect: {exc}")
        print("Is the research build running with a match started?")
        return 1

    print(f"Handshake: {hello}")

    try:
        # Wait for the first state snapshot.
        state = bridge.wait_state(timeout=10.0)
        debug_state = bridge.request_full_state(timeout=10.0)
        print(f"First state @ frame {state['frame']}:")
        for ch in debug_state["chars"]:
            print(
                f"  P{ch['id']} {ch['name']:<12} pos=({ch['x']:.1f},{ch['y']:.1f}) "
                f"vel=({ch['xs']:.2f},{ch['ys']:.2f}) dmg={ch['damage']:.0f} "
                f"lives={ch['lives']} state={ch['state']} cpu={ch['cpu']}"
            )

        # Observe ~2 seconds of frames to confirm streaming.
        t0 = time.monotonic()
        frames = 0
        last_frame = state["frame"]
        while time.monotonic() - t0 < 2.0:
            s = bridge.wait_state(timeout=2.0, min_frame=last_frame + 1)
            frames += 1
            last_frame = s["frame"]
        print(f"Streamed {frames} frames in ~2s (last frame {last_frame}).")

        # Take over player 2 and drive it with a fixed input sequence.
        p2 = next((c for c in debug_state["chars"] if c["id"] == 2), None)
        if p2 is None:
            print("No player 2 found; skipping input injection test.")
            return 0
        if not p2["cpu"]:
            print("Taking over player slot 2 ...")
            bridge.takeover(2)
            time.sleep(0.5)

        print("Injecting inputs: run right for 30 frames, then jump ...")
        right = Controls().set("RIGHT").mask
        right_jump = Controls().set("RIGHT").set("JUMP").mask
        for _ in range(30):
            bridge.send_input(2, right)
            time.sleep(1 / 30)
        for _ in range(5):
            bridge.send_input(2, right_jump)
            time.sleep(1 / 30)
        for _ in range(30):
            bridge.send_input(2, 0)
            time.sleep(1 / 30)

        bridge.wait_state(timeout=5.0)
        after = bridge.request_full_state(timeout=5.0)
        p2_after = next((c for c in after["chars"] if c["id"] == 2), None)
        if p2_after:
            print(
                f"P2 after injection: pos=({p2_after['x']:.1f},{p2_after['y']:.1f}) "
                f"vel=({p2_after['xs']:.2f},{p2_after['ys']:.2f}) "
                f"(was x={p2['x']:.1f})"
            )
            moved = abs(p2_after["x"] - p2["x"]) > 1.0
            print("RESULT:", "PASS - character moved under bridge control" if moved else "INCONCLUSIVE - no visible movement (may be stuck/wall)")
        print("Events:", bridge.drain_events())
        return 0
    finally:
        bridge.close()


if __name__ == "__main__":
    raise SystemExit(main())
