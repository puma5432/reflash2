#!/usr/bin/env python3
"""Test .ssfrec replay loading and state collection.

Usage: .venv/bin/python tools/rl/integration_tests/test_replay.py
"""
from __future__ import annotations

import argparse
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "python"))

from ssf2_rl.env.gym_env import SSF2Env


def _check_episode(episode) -> tuple[np.ndarray, np.ndarray]:
    if not episode.frames:
        raise AssertionError("replay collection returned no frames")
    frames = [frame["frame"] for frame in episode.frames]
    if frames != list(range(frames[0], frames[0] + len(frames))):
        raise AssertionError("collected replay frame numbers are not contiguous")
    obs, actions = episode.to_bc_dataset(player_id=1)
    if obs.shape != (len(episode), 38) or actions.dtype != np.int32:
        raise AssertionError(f"unexpected BC dataset shapes/types: {obs.shape}, {actions.dtype}")
    return obs, actions


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fast", action="store_true", help="collect only the fast native replay path")
    parser.add_argument("--compare-fast", action="store_true", help="compare realtime and fast parity")
    args = parser.parse_args()
    replay_path = next(Path("notebooks/data").rglob("*.ssfrec"))

    env = SSF2Env(step_timeout=10.0)
    try:
        realtime = None
        if not args.fast:
            started = time.perf_counter()
            realtime = env.replay_ssfrec(str(replay_path), collect=True, speed="realtime")
            realtime_seconds = time.perf_counter() - started
            realtime_obs, realtime_actions = _check_episode(realtime)
            print(f"Realtime: {len(realtime)} frames in {realtime_seconds:.3f}s")
            print(f"BC dataset: obs shape={realtime_obs.shape}, actions shape={realtime_actions.shape}")

        if args.fast or args.compare_fast:
            started = time.perf_counter()
            fast = env.replay_ssfrec(str(replay_path), collect=True, speed="fast", batch_frames=256)
            fast_seconds = time.perf_counter() - started
            fast_obs, fast_actions = _check_episode(fast)
            print(f"Fast: {len(fast)} frames in {fast_seconds:.3f}s")
            if args.compare_fast and realtime is not None:
                realtime_obs, realtime_actions = _check_episode(realtime)
                assert [frame["frame"] for frame in fast.frames] == [frame["frame"] for frame in realtime.frames]
                np.testing.assert_array_equal(fast_actions, realtime_actions)
                np.testing.assert_array_equal(fast_obs, realtime_obs)
                assert fast_seconds < realtime_seconds
                print(f"Parity OK; speedup: {realtime_seconds / fast_seconds:.1f}x")
        return 0
    finally:
        env.close()


if __name__ == "__main__":
    raise SystemExit(main())
