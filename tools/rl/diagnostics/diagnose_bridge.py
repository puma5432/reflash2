"""One-shot diagnostic: is the RL bridge receiving and applying agent inputs?

NOTE: the game only supports ONE bridge client at a time. Running this will
disconnect any notebook that is currently connected; re-run env.reset() in the
notebook afterwards.

Usage: .venv/bin/python tools/rl/diagnostics/diagnose_bridge.py
"""
from __future__ import annotations

import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "python"))

from ssf2_rl import SSF2Bridge  # noqa: E402
from ssf2_rl.game.controls import BITS, describe_mask  # noqa: E402

RIGHT = BITS["RIGHT"]


def me_of(state, pid=1):
    return next(c for c in state["chars"] if c["id"] == pid)


def main() -> int:
    b = SSF2Bridge(timeout=10)
    hello = b.connect()
    print("1) handshake ok:", hello)

    state = b.wait_state(timeout=5)
    print(
        f"2) live state: frame={state['frame']} paused={state['paused']} "
        f"ended={state['ended']}"
    )
    for c in state["chars"]:
        print(
            f"   P{c['id']} {str(c.get('name')):<10} cpu={c['cpu']} "
            f"x={c['x']:+.1f} controls={describe_mask(c['controls'])}"
        )

    # Take over player 1 and confirm the flag flipped.
    b.takeover(1)
    time.sleep(0.3)
    state = b.wait_state(timeout=5, min_frame=state["frame"] + 1)
    me = me_of(state)
    print(f"3) after takeover: P1 cpu={me['cpu']}  (must be 1 for inputs to apply)")
    if me["cpu"] != 1:
        print("   FAIL: takeover did not stick - inputs will be silently dropped.")
        b.close()
        return 1

    # Hold RIGHT for 30 frames and watch x + control bits.
    last = state["frame"]
    xs, ctrls = [], []
    for _ in range(30):
        b.send_input(1, RIGHT)
        s = b.wait_state(timeout=2, min_frame=last + 1)
        last = s["frame"]
        m = me_of(s)
        xs.append(m["x"])
        ctrls.append(m["controls"])

    right_frames = sum(1 for c in ctrls if c & RIGHT)
    print(f"4) held RIGHT for 30 steps:")
    print(f"   x: {xs[0]:+.1f} -> {xs[-1]:+.1f}  (delta {xs[-1] - xs[0]:+.1f})")
    print(f"   RIGHT bit visible in state controls on {right_frames}/30 frames")

    if xs[-1] > xs[0] + 1.0:
        print("VERDICT: WORKING - inputs are received and move the character.")
        b.close()
        return 0

    print("VERDICT: NOT WORKING - inputs are not moving the character.")
    print("   Likely causes: match paused/ended, takeover lost after a match")
    print("   restart, or Python is too slow and frames are skipped.")
    b.close()
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
