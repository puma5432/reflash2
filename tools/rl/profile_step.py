#!/usr/bin/env python3
"""Profile where synchronous step latency goes.

Separates:
  - ping round-trip: transport + AIR event dispatch, no simulation
  - step round-trip: transport + one PERFORMALL tick + state build + reply
  - Python-side overhead: obs/reward construction in env.step()

Usage: .venv/bin/python tools/rl/profile_step.py [--frames 300]
"""
from __future__ import annotations

import argparse
import statistics
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "python"))

from ssf2_rl.policy.bots import ZeroBot  # noqa: E402
from ssf2_rl.env.gym_env import SSF2Env  # noqa: E402
from ssf2_rl.game.catalog import Character, Stage  # noqa: E402


def pct(values: list[float], p: float) -> float:
    return statistics.quantiles(values, n=100)[p - 1] if len(values) >= 100 else max(values)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--frames", type=int, default=300)
    ap.add_argument("--transport", default="json", choices=["json", "binary-v3"])
    args = ap.parse_args()

    env = SSF2Env(
        lockstep=True,
        lockstep_mode="synchronous",
        state_transport=args.transport,
        step_timeout=10.0,
    )
    try:
        _, info = env.reset(
            players={1: ZeroBot(Character.Marth), 2: ZeroBot(Character.ZeroSuitSamus)},
            stage=Stage.bf,
        )
        bridge = env._bridge
        assert bridge is not None

        # Warm up.
        for _ in range(30):
            env.step(0)

        # 1) Ping round-trip: pure transport + AIR event dispatch (no sim).
        ping_ms: list[float] = []
        for _ in range(args.frames):
            t0 = time.perf_counter()
            bridge.ping()
            # pong has no request id; drain until we see it.
            deadline = time.monotonic() + 5.0
            while True:
                events = bridge.drain_events()
                if any(e.get("type") == "pong" for e in events):
                    break
                if time.monotonic() > deadline:
                    raise RuntimeError("pong timeout")
                time.sleep(0.0002)
            ping_ms.append((time.perf_counter() - t0) * 1000)

        # 2) Raw step round-trip: send step_sync, wait for step_complete.
        #    This includes sim tick + state build + transport, but NOT
        #    env.step()'s obs/reward construction.
        step_ms: list[float] = []
        prev_frame = env._last_state["frame"]
        for _ in range(args.frames):
            t0 = time.perf_counter()
            req = bridge.step_frame_sync()
            reply = bridge.wait_reply(req, "step_complete", timeout=10.0)
            step_ms.append((time.perf_counter() - t0) * 1000)
            state = reply["state"]
            assert state["frame"] == prev_frame + 1
            prev_frame = state["frame"]
            env._last_state = state  # keep env consistent

        # 3) Full env.step(): adds obs/reward/info construction on top.
        full_ms: list[float] = []
        for _ in range(args.frames):
            t0 = time.perf_counter()
            env.step(0)
            full_ms.append((time.perf_counter() - t0) * 1000)

        def report(name: str, ms: list[float]) -> None:
            mean = statistics.fmean(ms)
            print(
                f"{name:28s} mean={mean:6.2f}ms  p50={statistics.median(ms):6.2f}ms  "
                f"p95={pct(ms, 95):6.2f}ms  max={max(ms):6.2f}ms  -> {1000/mean:6.1f} FPS"
            )

        print(f"transport={args.transport}  frames={args.frames}")
        report("ping round-trip", ping_ms)
        report("step_sync round-trip", step_ms)
        report("env.step() total", full_ms)
        overhead = statistics.fmean(full_ms) - statistics.fmean(step_ms)
        print(f"{'python obs/reward overhead':28s} mean={overhead:6.2f}ms")
        sim_est = statistics.fmean(step_ms) - statistics.fmean(ping_ms)
        print(f"{'sim+statebuild (est)':28s} mean={sim_est:6.2f}ms")
        return 0
    finally:
        env.close()


if __name__ == "__main__":
    raise SystemExit(main())
