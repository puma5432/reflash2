"""Gymnasium environment wrapping the SSF2 research bridge.

Observation: a flat float32 vector built from the schema-2 state (agent char,
opponent char, and opponent-relative features). Action: Discrete over a fixed
set of named control masks (idle / move / jump / attack / special / shield /
grab / combos). Reward: damage-delta shaping + KO bonuses (configurable).

reset() sends a `restart_match` command so each episode starts from a fresh
local VS match (auto-started by the instrumented build).
"""

from __future__ import annotations

import math
from typing import Any, Optional

import numpy as np

try:
    import gymnasium as gym
    from gymnasium import spaces
except ImportError as exc:  # pragma: no cover
    raise ImportError("pip install 'ssf2-rl[rl]' (gymnasium) to use SSF2Env") from exc

from .bridge import SSF2Bridge, BridgeError
from .controls import Controls

# Default bridge endpoint
DEFAULT_HOST = "127.0.0.1"
DEFAULT_PORT = 4567

# Normalization constants (stage coords are roughly +/- 300 x, +/- 250 y;
# speeds ~ +/- 20; damage 0-999; shield 0-100).
_POS = 400.0
_VEL = 25.0
_DMG = 300.0


def _norm(v: float, scale: float) -> float:
    return max(-1.0, min(1.0, float(v) / scale))


# ---- Action space: named control masks -------------------------------------
def _mask(**kw: bool) -> int:
    c = Controls()
    for name, on in kw.items():
        c.set(name, on)
    return int(c)


ACTION_TABLE: list[tuple[str, int]] = [
    ("noop", 0),
    ("left", _mask(LEFT=True)),
    ("right", _mask(RIGHT=True)),
    ("up", _mask(UP=True)),
    ("down", _mask(DOWN=True)),
    ("jump", _mask(JUMP=True)),
    ("attack", _mask(BUTTON1=True)),
    ("special", _mask(BUTTON2=True)),
    ("shield", _mask(SHIELD=True)),
    ("grab", _mask(GRAB=True)),
    ("left_jump", _mask(LEFT=True, JUMP=True)),
    ("right_jump", _mask(RIGHT=True, JUMP=True)),
    ("left_attack", _mask(LEFT=True, BUTTON1=True)),
    ("right_attack", _mask(RIGHT=True, BUTTON1=True)),
    ("left_special", _mask(LEFT=True, BUTTON2=True)),
    ("right_special", _mask(RIGHT=True, BUTTON2=True)),
    ("jump_attack", _mask(JUMP=True, BUTTON1=True)),
    ("jump_special", _mask(JUMP=True, BUTTON2=True)),
    ("down_attack", _mask(DOWN=True, BUTTON1=True)),
    ("up_attack", _mask(UP=True, BUTTON1=True)),
    ("cstick_attack", _mask(C_RIGHT=True)),
]

ACTION_NAMES = [name for name, _ in ACTION_TABLE]
ACTION_MASKS = [mask for _, mask in ACTION_TABLE]

# Observation layout (mirrors _char_vec / _obs ordering) ----------------------
CHAR_FEATURES = [
    "x", "y", "nxs", "nys", "facing", "damage", "stocks", "ground",
    "jumpCount", "shieldPower", "shielding", "hitstun", "attacking",
    "atkExec", "hanging", "dead",
]


def obs_feature_names() -> list[str]:
    """Human-readable name for each index of the 38-dim observation vector."""
    return (
        [f"me_{f}" for f in CHAR_FEATURES]
        + [f"opp_{f}" for f in CHAR_FEATURES]
        + ["rel_dx", "rel_dy", "rel_dist", "facing_align", "frame", "paused"]
    )


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
    ) -> None:
        self._host = host
        self._port = port
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
        n_obs = 16 + 16 + 4 + 2
        self.observation_space = spaces.Box(low=-1.0, high=1.0, shape=(n_obs,), dtype=np.float32)
        self.action_space = spaces.Discrete(len(ACTION_TABLE))

    # -- lifecycle -----------------------------------------------------------

    def _connect(self) -> SSF2Bridge:
        if self._bridge is None:
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
        chars = {c["id"]: c for c in state["chars"]}
        me = chars.get(self.agent_player)
        opp_id = next((cid for cid in chars if cid != self.agent_player), None)
        return me, chars.get(opp_id)

    def _any_ko(self, state: dict) -> bool:
        return any(c["stocks"] <= 0 for c in state["chars"])

    def _char_vec(self, c: dict) -> list[float]:
        return [
            _norm(c["x"], _POS), _norm(c["y"], _POS),
            _norm(c["nxs"], _VEL), _norm(c["nys"], _VEL),
            1.0 if c["facing"] else -1.0,
            _norm(c["damage"], _DMG),
            _norm(c["stocks"], 5.0),
            1.0 if c["ground"] else -1.0,
            _norm(c["jumpCount"], 3.0),
            _norm(c["shieldPower"], 100.0),
            1.0 if c["shielding"] else -1.0,
            1.0 if c["hitstun"] else -1.0,
            1.0 if c["atkFrame"] else -1.0,
            _norm(c["atkExec"], 60.0),
            1.0 if c["hanging"] else -1.0,
            1.0 if c["dead"] else -1.0,
        ]

    def _obs(self, state: dict) -> np.ndarray:
        me, opp = self._chars(state)
        if me is None or opp is None:
            return np.zeros(self.observation_space.shape, dtype=np.float32)
        dx = opp["x"] - me["x"]
        dy = opp["y"] - me["y"]
        dist = math.sqrt(dx * dx + dy * dy)
        vec = (
            self._char_vec(me)
            + self._char_vec(opp)
            + [
                _norm(dx, _POS), _norm(dy, _POS), _norm(dist, _POS),
                1.0 if (dx >= 0) == bool(me["facing"]) else -1.0,
            ]
            + [_norm(state["frame"], 1e5), 1.0 if state["paused"] else -1.0]
        )
        return np.asarray(vec, dtype=np.float32)

    def _info(self, state: dict) -> dict:
        me, opp = self._chars(state)
        return {
            "frame": state["frame"],
            "me": me,
            "opp": opp,
        }

    def _reward(self, prev: dict, cur: dict) -> float:
        pme, popp = self._chars(prev)
        me, opp = self._chars(cur)
        if pme is None or popp is None or me is None or opp is None:
            return 0.0
        r = 0.0
        # Damage dealt is good; damage taken is bad.
        r += (opp["damage"] - popp["damage"]) / 10.0
        r -= (me["damage"] - pme["damage"]) / 10.0
        # Stock changes (KOs).
        r += (popp["stocks"] - opp["stocks"]) * self.ko_bonus
        r -= (pme["stocks"] - me["stocks"]) * self.ko_bonus
        return r * self.reward_scale


# Register so users can `gym.make("SSF2-v0")` after importing ssf2_rl.env.
gym.register(id="SSF2-v0", entry_point="ssf2_rl.env:SSF2Env")
