"""Episode container for collected trajectories.

An ``Episode`` stores a sequence of per-frame state snapshots collected from
the game, along with match metadata. It provides helpers for behavioral
cloning (extracting observation/action pairs) and replay debugging.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Optional

import numpy as np

from .obs import build_obs, reward_delta


@dataclass
class Episode:
    """A recorded match episode.

    Attributes:
        frames: list of per-frame state dicts (same shape as minimal state).
        config: match configuration used (stage, characters, etc.).
        generation: match generation ID from the bridge.
    """

    frames: list[dict[str, Any]]
    config: dict[str, Any] = field(default_factory=dict)
    generation: int = 0

    def __len__(self) -> int:
        return len(self.frames)

    def to_bc_dataset(
        self,
        player_id: int,
        include_rewards: bool = False,
    ) -> tuple[np.ndarray, np.ndarray, Optional[np.ndarray]]:
        """Extract (observation, action) pairs for behavioral cloning.

        Args:
            player_id: which player's perspective to use.
            include_rewards: also return per-frame rewards.

        Returns:
            ``(observations, actions)`` or ``(observations, actions, rewards)``.
            Observations are float32 arrays of shape ``(N, OBS_DIM)``.
            Actions are int32 control masks of shape ``(N,)``.
        """
        obs_list = []
        action_list = []
        reward_list = []

        for i, frame in enumerate(self.frames):
            obs = build_obs(frame, player_id)
            char = next((c for c in frame["chars"] if c["id"] == player_id), None)
            action = char["controls"] if char else 0

            obs_list.append(obs)
            action_list.append(action)

            if include_rewards and i > 0:
                reward = reward_delta(self.frames[i - 1], frame, player_id)
                reward_list.append(reward)

        observations = np.stack(obs_list).astype(np.float32)
        actions = np.array(action_list, dtype=np.int32)

        if include_rewards:
            # Pad first reward with 0 to align lengths
            rewards = np.array([0.0] + reward_list, dtype=np.float32)
            return observations, actions, rewards

        return observations, actions

    def save(self, path: str | Path) -> None:
        """Save the episode to a JSON file."""
        data = {
            "format": "ssf2-episode-v1",
            "generation": self.generation,
            "config": self.config,
            "frame_count": len(self.frames),
            "frames": self.frames,
        }
        with open(path, "w") as fh:
            json.dump(data, fh)

    @classmethod
    def load(cls, path: str | Path) -> "Episode":
        """Load an episode from a JSON file."""
        with open(path) as fh:
            data = json.load(fh)
        if data.get("format") != "ssf2-episode-v1":
            raise ValueError(f"unrecognized episode format in {path}")
        return cls(
            frames=data["frames"],
            config=data.get("config", {}),
            generation=data.get("generation", 0),
        )

    def replay(self, env, slot: int = 1, render_controls: Optional[int] = None) -> None:
        """Replay the episode through an environment for visual debugging.

        Resets the env with the same config, then steps through each frame
        sending the recorded action for the given slot. The overlay shows
        the replayed controls if ``render_controls`` is set.

        Args:
            env: an ``SSF2Env`` instance (must be lockstep mode).
            slot: which player slot to replay actions for.
            render_controls: overlay player ID (defaults to ``slot``).
        """
        from .bots import ScriptedBot
        from .players import Character

        if not env.lockstep:
            raise ValueError("replay requires lockstep mode")

        # Build a script from the recorded actions
        script = []
        for frame in self.frames:
            char = next((c for c in frame["chars"] if c["id"] == slot), None)
            mask = char["controls"] if char else 0
            if script and script[-1][0] == mask:
                script[-1] = (mask, script[-1][1] + 1)
            else:
                script.append((mask, 1))

        # Create a bot that replays the script
        character = self.config.get("characters", [None, None])[slot - 1]
        bot = ScriptedBot(Character(character) if character else None, script, on_end="hold")

        # Reset with the bot and replay
        players = {slot: bot}
        # Fill other slots with ZeroBot
        from .bots import ZeroBot
        for i in range(1, len(self.config.get("characters", 2)) + 1):
            if i != slot:
                players[i] = ZeroBot()

        env.reset(
            players=players,
            stage=self.config.get("stage", "battlefield"),
            render_controls=render_controls or slot,
        )

        # Step through the episode
        for _ in range(len(self.frames)):
            env.step()
