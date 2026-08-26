"""Gymnasium environment wrapping the SSF2 research bridge.

Observation: a flat float32 vector built from the schema-2 state (agent char,
opponent char, and opponent-relative features). Action: Discrete over a fixed
set of named control masks (idle / move / jump / attack / special / shield /
grab / combos). Reward: damage-delta shaping + KO bonuses (configurable).

reset() sends a request-correlated `restart_match` command so each episode
starts from a fresh local VS match configured by the caller.
"""

from __future__ import annotations

from typing import Any, Optional, Union
from time import perf_counter

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
        step_timeout: float = 5.0,
        reward_scale: float = 1.0,
        ko_bonus: float = 10.0,
        config: Optional[dict] = None,
        auto_launch: bool = True,
        lockstep: bool = False,
        lockstep_mode: str = "render",
        state_transport: str = "json",
        players: Optional[dict[int, Player]] = None,
        stage: Union[str, Stage] = "finaldestination",
        lives: int = 99,
        render_controls: int = 0,
    ) -> None:
        self._host = host
        self._port = port
        self.auto_launch = auto_launch
        self.lockstep = bool(lockstep)
        if lockstep_mode not in {"render", "synchronous"}:
            raise ValueError("lockstep_mode must be 'render' or 'synchronous'")
        if lockstep_mode == "synchronous" and not self.lockstep:
            raise ValueError("lockstep_mode='synchronous' requires lockstep=True")
        self.lockstep_mode = lockstep_mode
        self.state_transport = state_transport
        self.agent_player = agent_player
        self.max_episode_frames = max_episode_frames
        self.step_timeout = step_timeout
        self.reward_scale = reward_scale
        self.ko_bonus = ko_bonus
        self.config = config
        self.stage = stage
        self.lives = lives
        self.render_controls = int(render_controls)
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
        self._lockstep_paused = False
        self._last_step_seconds = 0.0

        # Observation: agent(16) + opponent(16) + relative(4) + match(2)
        self.observation_space = spaces.Box(low=-1.0, high=1.0, shape=(OBS_DIM,), dtype=np.float32) # TODO: spaces.box() seems like a good fit. Could experiment with later
        self.action_space = spaces.Discrete(len(ACTION_TABLE)) # TODO: should I use multibinary spaces, or do I need to use the bit mask?

    # -- lifecycle -----------------------------------------------------------

    def _connect(self) -> SSF2Bridge:
        if self._bridge is None:
            if self.auto_launch:
                # Start the game if it isn't running yet; no-op otherwise.
                ensure_game_running(self._host, self._port)
            self._bridge = SSF2Bridge(
                self._host,
                self._port,
                timeout=15.0,
                state_transport=self.state_transport,
            )
            self._bridge.connect()
        return self._bridge

    def reset(
        self,
        *,
        seed: Optional[int] = None,
        options: Optional[dict] = None,
        players: Optional[dict[int, Player]] = None,
        stage: Optional[Union[str, Stage]] = None,
        render_controls: Optional[int] = None,
    ):
        """Restart the match and take over the bot slots.

        Args:
            players: optional per-reset override of the slot declarations
                (e.g. ``{1: Agent(Character.Marth), 2: CPU(Character.Samus, level=0)}``).
            stage: optional per-reset stage override — a ``Stage`` member or
                raw id (see ``players.STAGES``).
            render_controls: optional per-reset overlay override — show held
                controls for this player slot in-game (0 hides the overlay).
        """
        super().reset(seed=seed)
        if players is not None:
            self._validate_players(players, self.agent_player)
            self.players = players
        if stage is not None:
            self.stage = stage
        if render_controls is not None:
            self.render_controls = int(render_controls)

        # Build the match config from the declarations (unless a raw config
        # was passed to the constructor, which still takes precedence).
        config = self.config or build_match_config(
            self.players, stage=self.stage, lives=self.lives
        )
        bridge = self._connect()
        # Drop stale old-match traffic before request-correlating this reset.
        bridge.clear_pending_messages()
        request = bridge.restart_match(config)
        bridge.wait_reply(request, "ack", timeout=30.0)
        reply = bridge.wait_reply(request, "match_ready", timeout=30.0)
        state = self._reply_state(reply, "restart")
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
        # Show/hide the in-game controls overlay for the requested slot.
        bridge.set_overlay(self.render_controls)
        if self.lockstep:
            request = bridge.pause()
            reply = bridge.wait_reply(request, "ack", timeout=self.step_timeout)
            state = self._reply_state(reply, "pause")
            if not state.get("paused"):
                raise BridgeError("lockstep pause acknowledgement was not paused")
            self._lockstep_paused = True
        else:
            self._lockstep_paused = False
        self._last_state = state
        self._frames_in_episode = 0
        self._last_step_seconds = 0.0
        for decl in self.players.values():
            if isinstance(decl, Bot):
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
        started = perf_counter()
        bridge = self._connect()
        prev = self._last_state
        if prev is None:
            raise BridgeError("call reset() before step()")
        if self.lockstep and not self._lockstep_paused:
            raise BridgeError("lockstep environment is not paused; call reset()")
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
        if self.lockstep:
            request = bridge.step_frame_sync() if self.lockstep_mode == "synchronous" else bridge.step_frame()
            reply = bridge.wait_reply(request, "step_complete", timeout=self.step_timeout)
            state = self._reply_state(reply, "step")
            expected_frame = prev["frame"] + 1
            if state.get("frame") != expected_frame:
                raise BridgeError(
                    f"lockstep step advanced from frame {prev['frame']} to "
                    f"{state.get('frame')}, expected {expected_frame}"
                )
            if not state.get("paused"):
                raise BridgeError("lockstep step completed without pausing the game")
            self._lockstep_paused = True
        else:
            state = bridge.wait_state(timeout=self.step_timeout, min_frame=prev["frame"] + 1)
            # Dropped-frame accounting: if the game advanced more than one frame
            # while we were working, our bots missed the frames in between.
            gap = state["frame"] - prev["frame"] - 1
            if gap > 0:
                self._dropped_frames += gap
        self._last_state = state
        self._frames_in_episode += 1
        self._last_step_seconds = perf_counter() - started

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
        """Run a sequence of environment steps.

        In normal mode, the loop is paced by the game (normally 30 FPS), so
        you can watch or play a human slot in real time. In lockstep mode,
        each iteration permits exactly one game frame and pauses it again;
        the loop is therefore not interactive in real time.

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

    def record_human(
        self,
        player_id: int,
        frames: Optional[int] = None,
        until_done: bool = True,
    ) -> list[tuple[int, int]]:
        """Record a human player's held controls as a ScriptedBot script.

        Runs the match in normal (non-lockstep) mode so the human can play in
        real time. Reads the character's actual held control bits each frame
        and RLE-compresses consecutive identical masks into ``(mask, count)``
        tuples — the exact format ``ScriptedBot`` expects.

        Args:
            player_id: which slot to record (must be a Human declaration).
            frames: maximum frames to record (None = until match ends).
            until_done: stop when the match ends / a stock hits 0.

        Returns:
            List of ``(mask, frames)`` tuples ready for ``ScriptedBot``.
        """
        if self.lockstep:
            raise BridgeError("record_human requires normal (non-lockstep) mode")
        decl = self.players.get(player_id)
        if not isinstance(decl, Human):
            raise ValueError(f"player {player_id} is not a Human declaration")

        bridge = self._connect()
        prev = self._last_state
        if prev is None:
            raise BridgeError("call reset() before record_human()")

        script: list[tuple[int, int]] = []
        current_mask: Optional[int] = None
        current_count = 0
        n = 0

        while frames is None or n < frames:
            state = bridge.wait_state(timeout=self.step_timeout, min_frame=prev["frame"] + 1)
            prev = state
            n += 1

            # Extract the human's held controls from the state.
            char = next((c for c in state["chars"] if c["id"] == player_id), None)
            mask = char["controls"] if char else 0

            if mask != current_mask:
                if current_count > 0:
                    script.append((current_mask, current_count))
                current_mask = mask
                current_count = 1
            else:
                current_count += 1

            if until_done and (bool(state["ended"]) or self._any_ko(state)):
                break

        # Flush the final run.
        if current_count > 0 and current_mask is not None:
            script.append((current_mask, current_count))

        self._last_state = prev
        print(f"record_human(): {n} frames -> {len(script)} script entries")
        return script

    def close(self) -> None:
        if self._bridge is not None:
            if self.lockstep and self._lockstep_paused:
                try:
                    request = self._bridge.resume()
                    self._bridge.wait_reply(request, "ack", timeout=1.0)
                except BridgeError:
                    pass
            self._bridge.close()
            self._bridge = None
        self._lockstep_paused = False

    def describe_matchup(self) -> str:
        """One-table summary of who controls every slot (and the stage)."""
        return describe_matchup(self.players, stage=self.stage)

    def request_full_state(self, timeout: float = 5.0) -> dict:
        """Return a full schema-2 debug snapshot outside the policy hot path."""
        return self._connect().request_full_state(timeout=timeout)

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
            "paused": bool(state.get("paused")),
            "lockstep": self.lockstep,
            "lockstep_mode": self.lockstep_mode,
            "state_transport": self._bridge.state_transport if self._bridge else self.state_transport,
            "step_seconds": self._last_step_seconds,
            "simulation_fps": 1.0 / self._last_step_seconds if self._last_step_seconds > 0 else 0.0,
            "me": me,
            "opp": opp,
        }

    @staticmethod
    def _reply_state(reply: dict, command: str) -> dict:
        """Extract and validate the state attached to a lockstep reply."""
        state = reply.get("state")
        if not isinstance(state, dict):
            raise BridgeError(f"lockstep {command} reply did not include a state snapshot")
        return state

    def _reward(self, prev: dict, cur: dict) -> float:
        return reward_delta(prev, cur, self.agent_player, ko_bonus=self.ko_bonus) * self.reward_scale


# Register so users can `gym.make("SSF2-v0")` after importing ssf2_rl.env.
gym.register(id="SSF2-v0", entry_point="ssf2_rl.env:SSF2Env")
