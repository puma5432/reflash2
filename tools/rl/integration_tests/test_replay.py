#!/usr/bin/env python3
"""Test .ssfrec replay loading and state collection.

Usage: .venv/bin/python tools/rl/integration_tests/test_replay.py
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "python"))

from ssf2_rl.env.gym_env import SSF2Env


def main() -> int:
    replay_path = "notebooks/data/2026-08-27 11.38 AM - Versus - P1 (Marth) vs CPU Lvl 9 (Samus).ssfrec"

    env = SSF2Env(step_timeout=10.0)
    try:
        episode = env.replay_ssfrec(replay_path, collect=True)
        print(f"Collected {len(episode)} frames")
        if len(episode) > 0:
            print(f"First frame: {episode.frames[0]['frame']}, last: {episode.frames[-1]['frame']}")
            obs, actions = episode.to_bc_dataset(player_id=1)
            print(f"BC dataset: obs shape={obs.shape}, actions shape={actions.shape}")
            print(f"Sample actions: {actions[:10]}")
        return 0
    finally:
        env.close()


if __name__ == "__main__":
    raise SystemExit(main())
