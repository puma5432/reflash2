"""Gymnasium environment wrapping the SSF2 research bridge.

Observation: a flat float32 vector built from the schema-2 state (agent char,
opponent char, and opponent-relative features). Action: Discrete over a fixed
set of named control masks (idle / move / jump / attack / special / shield /
grab / combos). Reward: damage-delta shaping + KO bonuses (configurable).

reset() sends a `restart_match` command so each episode starts from a fresh
local VS match (auto-started by the instrumented build).
"""

from __future__ import annotations

from typing import Any, Optional

import numpy as np

try:
    import gymnasium as gym
    from gymnasium import spaces
except ImportError as exc:  # pragma: no cover
    raise ImportError("pip install 'ssf2-rl[rl]' (gymnasium) to use SSF2Env") from exc

from .actions import ACTION_TABLE, ACTION_NAMES, ACTION_MASKS
from .bridge import SSF2Bridge, BridgeError
from .launcher import ensure_game_running
from .obs import (
    CHAR_FEATURES,
    OBS_DIM,
    build_obs,
    obs_feature_names,
    pick_chars,
    reward_delta,
)

# Default bridge endpoint
DEFAULT_HOST = "127.0.0.1"
DEFAULT_PORT = 4567

# The action table lives in ssf2_rl.actions (shared with the bot layer);
# observation layout lives in ssf2_rl.obs. ACTION_TABLE / ACTION_NAMES /
# ACTION_MASKS / CHAR_FEATURES / obs_feature_names are re-exported above
# for backwards compatibility.


class SSF2Env(gym.Env):
    """Super Smash Flash 2 as a Gymnasium environment (1v1 local VS)."""

    metadata = {"render_modes": []}

    def __init__(
        self,
        host: str = DEFAULT_HOST,
        port: int = DEFAULT_PORT,
        agent_player: int = 1,
        max_episode_frames: int = 30 * 120,   # 2 min at 30 FPS
        step_timeout: float = 2.0,
        reward_scale: float = 1.0,
        ko_bonus: float = 10.0,
        config: Optional[dict] = None,
        auto_launch: bool = True,
    ) -> None:
        self._host = host
        self._port = port
        self.auto_launch = auto_launch
        self.agent_player = agent_player
        self.max_episode_frames = max_episode_frames
        self.step_timeout = step_timeout
        self.reward_scale = reward_scale
        self.ko_bonus = ko_bonus
        self.config = config

        self._bridge: Optional[SSF2Bridge] = None
        self._last_state: Optional[dict] = None
        self._frames_in_episode = 0

        # Observation: agent(16) + opponent(16) + relative(4) + match(2)
        self.observation_space = spaces.Box(low=-1.0, high=1.0, shape=(OBS_DIM,), dtype=np.float32) # TODO: spaces.box() seems like a good fit. Could experiment with later
        self.action_space = spaces.Discrete(len(ACTION_TABLE)) # TODO: should I use multibinary spaces, or do I need to use the bit mask?

    # -- lifecycle -----------------------------------------------------------

    def _connect(self) -> SSF2Bridge:
        if self._bridge is None:
            if self.auto_launch:
                # Start the game if it isn't running yet; no-op otherwise.
                ensure_game_running(self._host, self._port)
            self._bridge = SSF2Bridge(self._host, self._port, timeout=15.0)
            self._bridge.connect()
        return self._bridge

    def reset(self, *, seed: Optional[int] = None, options: Optional[dict] = None):
        super().reset(seed=seed)
        bridge = self._connect()
        # Restart the match for a fresh episode.
        bridge.restart_match(self.config)
        # Wait for a brand-new state stream (frame counter resets to ~0).
        state = self._wait_for_new_match(bridge)
        self._last_state = state
        self._frames_in_episode = 0
        # Take over the agent's slot so we can drive it.
        bridge.takeover(self.agent_player)
        return self._obs(state), self._info(state)

    def step(self, action: int):
        bridge = self._connect()
        mask = ACTION_MASKS[int(action) % len(ACTION_MASKS)]
        bridge.send_input(self.agent_player, mask)
        prev = self._last_state
        state = bridge.wait_state(timeout=self.step_timeout, min_frame=prev["frame"] + 1)
        self._last_state = state
        self._frames_in_episode += 1

        reward = self._reward(prev, state)
        terminated = bool(state["ended"]) or self._any_ko(state)
        truncated = self._frames_in_episode >= self.max_episode_frames
        return self._obs(state), reward, terminated, truncated, self._info(state)

    def close(self) -> None:
        if self._bridge is not None:
            self._bridge.close()
            self._bridge = None

    # -- helpers -------------------------------------------------------------

    def _wait_for_new_match(self, bridge: SSF2Bridge) -> dict:
        """After restart_match, the old frame counter is high; wait until we see
        a low frame number (new match) or a fresh state after a brief delay."""
        import time

        deadline = time.monotonic() + 20.0
        first = bridge.wait_state(timeout=10.0)
        # The restarted match starts its frame counter near 0.
        while time.monotonic() < deadline:
            s = bridge.wait_state(timeout=5.0)
            if s["frame"] < first["frame"] or s["frame"] < 90:
                return s
        return bridge.wait_state(timeout=5.0)

    def _chars(self, state: dict):
        return pick_chars(state, self.agent_player)

    def _any_ko(self, state: dict) -> bool:
        return any(c["stocks"] <= 0 for c in state["chars"])

    def _obs(self, state: dict) -> np.ndarray:
        return build_obs(state, self.agent_player)

    def _info(self, state: dict) -> dict:
        me, opp = self._chars(state)
        return {
            "frame": state["frame"],
            "me": me,
            "opp": opp,
        }

    def _reward(self, prev: dict, cur: dict) -> float:
        return reward_delta(prev, cur, self.agent_player, ko_bonus=self.ko_bonus) * self.reward_scale


# Register so users can `gym.make("SSF2-v0")` after importing ssf2_rl.env.
gym.register(id="SSF2-v0", entry_point="ssf2_rl.env:SSF2Env")
