#!/usr/bin/env python3
"""Live correctness and throughput validation for one active SSF2 environment."""

from __future__ import annotations

import argparse
from time import perf_counter

from ssf2_rl.bots import Agent, ZeroBot
from ssf2_rl.env import SSF2Env
from ssf2_rl.players import CPU, Human, Character, Stage


def validate_reported_bugs(normal_frames: int) -> None:
    env = SSF2Env(step_timeout=5.0)
    try:
        _, info = env.reset(
            players={1: Agent(Character.Marth), 2: ZeroBot(Character.ZeroSuitSamus)},
            stage=Stage.bf,
        )
        first_frame = info["frame"]
        later = env._bridge.wait_state(
            timeout=max(15.0, normal_frames / 20.0 + 10.0),
            min_frame=first_frame + normal_frames,
        )
        full = env._bridge.request_full_state()
        zss = next(char for char in full["chars"] if char["id"] == 2)
        assert zss["controls"] == 0, f"ZeroBot reverted to controls={zss['controls']}"
        print(f"PASS held ZeroBot: frames {first_frame}->{later['frame']}, controls=0")

        env.reset(
            players={1: Human(Character.Marth), 2: CPU(Character.Samus, level=9)},
            stage=Stage.bf,
        )
        env.run(frames=normal_frames)
        print(f"PASS sequential Human/CPU stream: {normal_frames} frames")
    finally:
        env.close()


def benchmark(transport: str, frames: int) -> None:
    env = SSF2Env(
        lockstep=True,
        lockstep_mode="synchronous",
        state_transport=transport,
        step_timeout=5.0,
    )
    try:
        _, info = env.reset(
            players={1: Agent(Character.Marth), 2: ZeroBot(Character.ZeroSuitSamus)},
            stage=Stage.bf,
        )
        previous = info["frame"]
        for _ in range(25):
            _, _, _, _, info = env.step(0)
            assert info["frame"] == previous + 1 and info["paused"]
            previous = info["frame"]

        started = perf_counter()
        for _ in range(frames):
            _, _, terminated, truncated, info = env.step(0)
            assert info["frame"] == previous + 1 and info["paused"]
            assert not terminated and not truncated
            previous = info["frame"]
        elapsed = perf_counter() - started
        fps = frames / elapsed
        print(
            f"PASS {transport}: {frames} exact frames in {elapsed:.3f}s, "
            f"{fps:.1f} FPS ({fps / 30:.2f}x real time)"
        )
    finally:
        env.close()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--frames", type=int, default=1000)
    parser.add_argument("--normal-frames", type=int, default=600)
    args = parser.parse_args()

    validate_reported_bugs(args.normal_frames)
    benchmark("json", args.frames)
    benchmark("binary-v3", args.frames)


if __name__ == "__main__":
    main()
