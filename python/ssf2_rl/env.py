"""Gymnasium environment wrapping the SSF2 research bridge.

Observation: a flat float32 vector built from the schema-2 state (agent char,
opponent char, and opponent-relative features). Action: Discrete over a fixed
set of named control masks (idle / move / jump / attack / special / shield /
grab / combos). Reward: damage-delta shaping + KO bonuses (configurable).

reset() sends a `restart_match` command so each episode starts from a fresh
local VS match (auto-started by the instrumented build).
"""

from __future__ import annotations

from typing import Any, Optional, Union

import numpy as np

try:
    import gymnasium as gym
    from gymnasium import spaces
except ImportError as exc:  # pragma: no cover
    raise ImportError("pip install 'ssf2-rl[rl]' (gymnasium) to use SSF2Env") from exc

from .actions import ACTION_TABLE, ACTION_NAMES, ACTION_MASKS
from .bots.base import Agent, Bot
from .bridge import SSF2Bridge, BridgeError
from .launcher import ensure_game_running
from .players import (
    CPU,
    Character,
    Human,
    Player,
    Stage,
    build_match_config,
    describe_matchup,
)
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
        players: Optional[dict[int, Player]] = None,
        stage: Union[str, Stage] = "finaldestination",
        lives: int = 99,
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
        self.stage = stage
        self.lives = lives
        # Default matchup: the agent slot is step-driven (Agent), the
        # opponent is the in-game CPU at level 0 (docile).
        self.players: dict[int, Player] = players or {
            1: Agent(Character.Marth),
            2: CPU(Character.Samus, level=0),
        }
        self._validate_players(self.players, agent_player)

        self._bridge: Optional[SSF2Bridge] = None
        self._last_state: Optional[dict] = None
        self._last_masks: dict[int, int] = {}
        self._frames_in_episode = 0
        self._dropped_frames = 0  # frames the loop missed (see run())

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

    def reset(
        self,
        *,
        seed: Optional[int] = None,
        options: Optional[dict] = None,
        players: Optional[dict[int, Player]] = None,
        stage: Optional[Union[str, Stage]] = None,
    ):
        """Restart the match and take over the bot slots.

        Args:
            players: optional per-reset override of the slot declarations
                (e.g. ``{1: Agent(Character.Marth), 2: CPU(Character.Samus, level=0)}``).
            stage: optional per-reset stage override — a ``Stage`` member or
                raw id (see ``players.STAGES``).
        """
        super().reset(seed=seed)
        if players is not None:
            self._validate_players(players, self.agent_player)
            self.players = players
        if stage is not None:
            self.stage = stage

        bridge = self._connect()
        # Build the match config from the declarations (unless a raw config
        # was passed to the constructor, which still takes precedence).
        config = self.config or build_match_config(
            self.players, stage=self.stage, lives=self.lives
        )
        # Make sure the current match is actually running before restarting;
        # restarting mid-load (e.g. right after auto-launch) crashes the game.
        bridge.wait_state(timeout=30.0)
        bridge.restart_match(config)
        # Wait for a brand-new state stream (frame counter resets to ~0).
        state = self._wait_for_new_match(bridge)
        self._last_state = state
        self._frames_in_episode = 0
        # Take over every non-Human slot. For Bot slots this lets the bridge
        # drive them; for CPU slots it is idempotent (already-CPU slots are
        # untouched) but required on slot 1, which the game's match config
        # always creates as human-controlled.
        for pid, decl in self.players.items():
            if isinstance(decl, Human):
                continue
            bridge.takeover(pid)
            if isinstance(decl, Bot):
                # Hold nothing until the first step(): without this, the
                # native CPU AI would fill any frame with no queued override.
                bridge.send_input(pid, 0)
                decl.reset()
                decl.on_match_start(state)
        return self._obs(state), self._info(state)

    def step(self, action: Optional[Union[int, dict[int, int]]] = None):
        """Advance exactly one game frame.

        Args:
            action: the agent slot's action. Three forms:
                - ``int``: an index into ``ACTION_NAMES`` (the RL path).
                - ``None``: the agent slot holds nothing (mask 0); useful
                  when the agent is a ``Human`` or you're just ticking bots.
                - ``dict``: explicit per-slot actions ``{pid: action_index}``
                  for full visibility (overrides the agent + any bot slot).

        Every taken-over (Bot) slot gets an explicit mask every frame — the
        default is 0, so a Bot slot never silently reverts to the in-game
        CPU and "controls == 0" always means Python is driving.
        """
        bridge = self._connect()
        prev = self._last_state
        if prev is None:
            raise BridgeError("call reset() before step()")
        masks: dict[int, int] = {}
        for pid, decl in self.players.items():
            if not isinstance(decl, Bot):
                continue  # Human/CPU slots get no Python input
            if isinstance(action, dict):
                if pid in action:
                    mask = ACTION_MASKS[int(action[pid]) % len(ACTION_MASKS)]
                else:
                    mask = int(decl.act(prev, pid))
            elif pid == self.agent_player and action is not None:
                mask = ACTION_MASKS[int(action) % len(ACTION_MASKS)]
            else:
                # No explicit action for this slot: its own bot decides
                # (Agent.act() returns 0, i.e. hold nothing).
                mask = int(decl.act(prev, pid))
            masks[pid] = mask
            bridge.send_input(pid, mask)
        self._last_masks = masks
        state = bridge.wait_state(timeout=self.step_timeout, min_frame=prev["frame"] + 1)
        # Dropped-frame accounting: if the game advanced more than one frame
        # while we were working, our bots missed the frames in between.
        gap = state["frame"] - prev["frame"] - 1
        if gap > 0:
            self._dropped_frames += gap
        self._last_state = state
        self._frames_in_episode += 1

        reward = self._reward(prev, state)
        terminated = bool(state["ended"]) or self._any_ko(state)
        truncated = self._frames_in_episode >= self.max_episode_frames
        return self._obs(state), reward, terminated, truncated, self._info(state)

    def run(
        self,
        frames: Optional[int] = None,
        until_done: bool = False,
        record: bool = False,
    ) -> dict[int, list[dict]]:
        """Real-time evaluation loop: ticks the game at its normal 30 FPS.

        The loop is paced by the game itself (each ``step()`` blocks until
        the next frame arrives), so the match plays at full speed while you
        watch/play. Bots on non-agent slots are ticked automatically; a
        ``Human`` agent slot means you play in the game window.

        Args:
            frames: maximum number of frames to run (None = unlimited).
            until_done: also stop early when the match ends / a stock hits 0.
            record: collect per-bot-slot trajectory dicts
                (``state``, ``obs``, ``mask``, ``reward``) for each frame.

        Returns:
            ``{player_id: [frame records]}`` when ``record`` else ``{}``.
        """
        if frames is None and not until_done:
            raise ValueError("pass frames=N and/or until_done=True")
        bot_slots = [pid for pid, d in self.players.items() if isinstance(d, Bot)]
        traj: dict[int, list[dict]] = {p: [] for p in bot_slots} if record else {}
        n = 0
        while frames is None or n < frames:
            prev = self._last_state
            obs, reward, terminated, truncated, info = self.step()
            if record:
                state = self._last_state
                for pid in bot_slots:
                    traj[pid].append({
                        "state": prev,
                        "obs": build_obs(prev, pid),
                        "mask": self._last_masks.get(pid, 0),
                        "reward": reward_delta(prev, state, pid, ko_bonus=self.ko_bonus),
                    })
            n += 1
            if (terminated or truncated) and until_done:
                break
        print(f"run(): {n} frames, {self._dropped_frames} dropped")
        return traj

    def close(self) -> None:
        if self._bridge is not None:
            self._bridge.close()
            self._bridge = None

    def describe_matchup(self) -> str:
        """One-table summary of who controls every slot (and the stage)."""
        return describe_matchup(self.players, stage=self.stage)

    @staticmethod
    def _validate_players(players: dict[int, Player], agent_player: int) -> None:
        """Check the matchup: the agent slot must exist.

        The agent slot anchors observations/rewards and receives the
        ``step(action)`` input. Any declaration is allowed there: an
        ``Agent``/``Bot`` is driven by Python, a ``CPU``/``Human`` just
        plays natively (spectating / play-it-yourself matchups).
        """
        if agent_player not in players:
            raise ValueError(f"agent_player={agent_player} has no player declaration")

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
