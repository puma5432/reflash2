"""Episode container for collected SSF2 trajectories."""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Optional
import numpy as np
from ..policy.observation import build_obs
from ..policy.reward import reward_delta


@dataclass
class Episode:
    frames: list[dict[str, Any]]
    config: dict[str, Any] = field(default_factory=dict)
    generation: int = 0

    def __len__(self) -> int:
        return len(self.frames)

    def to_bc_dataset(self, player_id: int, include_rewards: bool = False):
        observations, actions, rewards = [], [], []
        for index, frame in enumerate(self.frames):
            observations.append(build_obs(frame, player_id))
            character = next((char for char in frame["chars"] if char["id"] == player_id), None)
            actions.append(character["controls"] if character else 0)
            if include_rewards and index > 0:
                rewards.append(reward_delta(self.frames[index - 1], frame, player_id))
        result = (np.stack(observations).astype(np.float32), np.asarray(actions, dtype=np.int32))
        return result + (np.asarray([0.0] + rewards, dtype=np.float32),) if include_rewards else result

    def save(self, path: str | Path) -> None:
        with open(path, "w") as handle:
            json.dump({"format": "ssf2-episode-v1", "generation": self.generation, "config": self.config, "frame_count": len(self.frames), "frames": self.frames}, handle)

    @classmethod
    def load(cls, path: str | Path) -> "Episode":
        with open(path) as handle:
            data = json.load(handle)
        if data.get("format") != "ssf2-episode-v1":
            raise ValueError(f"unrecognized episode format in {path}")
        return cls(data["frames"], data.get("config", {}), data.get("generation", 0))

    def replay(self, env, slot: int = 1, render_controls: Optional[int] = None) -> None:
        from ..game.catalog import Character
        from ..policy.bots import ScriptedBot, ZeroBot
        if not env.lockstep:
            raise ValueError("replay requires lockstep mode")
        script: list[tuple[int, int]] = []
        for frame in self.frames:
            character = next((char for char in frame["chars"] if char["id"] == slot), None)
            mask = character["controls"] if character else 0
            if script and script[-1][0] == mask:
                script[-1] = (mask, script[-1][1] + 1)
            else:
                script.append((mask, 1))
        character = self.config.get("characters", [None, None])[slot - 1]
        players = {slot: ScriptedBot(Character(character) if character else None, script, on_end="hold")}
        for player_id in range(1, len(self.config.get("characters", 2)) + 1):
            if player_id != slot:
                players[player_id] = ZeroBot()
        env.reset(players=players, stage=self.config.get("stage", "battlefield"), render_controls=render_controls or slot)
        for _ in self.frames:
            env.step()
