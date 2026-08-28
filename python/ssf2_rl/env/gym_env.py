"""Gymnasium environment wrapping the SSF2 research bridge."""
from __future__ import annotations
from time import perf_counter
from typing import Optional, Union
import numpy as np
try:
    import gymnasium as gym
    from gymnasium import spaces
except ImportError as exc: raise ImportError("pip install 'ssf2-rl[rl]' (gymnasium) to use SSF2Env") from exc
from ..data.episode import Episode
from ..game.catalog import Character, Stage
from ..game.launcher import ensure_game_running
from ..game.players import CPU, Human, Player, build_match_config, describe_matchup
from ..policy.actions import ACTION_MASKS, ACTION_TABLE
from ..policy.bots.base import Agent, Bot
from ..policy.observation import OBS_DIM, build_obs, pick_chars
from ..policy.reward import reward_delta
from ..protocol.bridge import BridgeError, SSF2Bridge
from .match import reply_state, reset_match, validate_players
from .replay import replay_ssfrec

DEFAULT_HOST, DEFAULT_PORT = "127.0.0.1", 4567

class SSF2Env(gym.Env):
    """Super Smash Flash 2 as a Gymnasium-compatible 1v1 environment."""
    metadata = {"render_modes": []}
    def __init__(self,
                 players: Optional[dict[int, Player]] = None,
                 max_episode_frames: int = 30 * 120,
                 step_timeout: float = 5.0,
                 lockstep: bool = False,
                 lockstep_mode: str = "render",

                 auto_launch: bool = True,
                 host: str = DEFAULT_HOST,
                 port: int = DEFAULT_PORT,
                 agent_player: int = 1,
                 reward_scale: float = 1.0,
                 ko_bonus: float = 10.0,
                 config: Optional[dict] = None,
                 state_transport: str = "json",
                 stage: Union[str, Stage] = "finaldestination",
                 lives: int = 99,
                 render_controls: int = 0) -> None:

        self._host, self._port, self.auto_launch = host, port, auto_launch;
        self.lockstep = bool(lockstep)
        if lockstep_mode not in {"render", "synchronous"}:
            raise ValueError("lockstep_mode must be 'render' or 'synchronous'")
        if lockstep_mode == "synchronous" and not self.lockstep:
            raise ValueError("lockstep_mode='synchronous' requires lockstep=True")
        self.lockstep_mode, self.state_transport = lockstep_mode, state_transport;

        self.max_episode_frames, self.step_timeout, self.reward_scale, self.ko_bonus = max_episode_frames, step_timeout, reward_scale, ko_bonus
        self.config, self.stage, self.lives, self.render_controls = config, stage, lives, int(render_controls)

        self.agent_player = agent_player
        self.players = players or {1: Agent(Character.Marth), 2: CPU(Character.Samus, level=0)};
        validate_players(self.players, agent_player)
        self._bridge: Optional[SSF2Bridge] = None;
        self._last_state: Optional[dict] = None;
        self._last_masks: dict[int, int] = {}
        self._frames_in_episode = self._dropped_frames = 0;
        self._lockstep_paused = False;
        self._last_step_seconds = 0.

        self.observation_space = spaces.Box(-1., 1., (OBS_DIM,), dtype=np.float32);
        #TODO: instead of having everything be normalized to -1,1, what if you didn't normalize them? How would
        # that change the process of learning?
        self.action_space = spaces.Discrete(len(ACTION_TABLE))
        #TODO: ^ change so action space is the actual 22-bit mask, except without the ability to pause the game

    def _connect(self) -> SSF2Bridge:
        if self._bridge is None:
            if self.auto_launch:
                ensure_game_running(self._host, self._port)
            self._bridge = SSF2Bridge(self._host,
                                      self._port,
                                      timeout=15.,
                                      state_transport=self.state_transport);
            self._bridge.connect()
        return self._bridge

    def reset(self, *,
              seed: Optional[int] = None,
              options: Optional[dict] = None,
              players: Optional[dict[int, Player]] = None,
              stage: Optional[Union[str, Stage]] = None,
              render_controls: Optional[int] = None):

        super().reset(seed=seed)
        if players is not None:
            validate_players(players, self.agent_player); self.players = players
        if stage is not None:
            self.stage = stage
        if render_controls is not None:
            self.render_controls = int(render_controls)
        state = reset_match(self);
        self._last_state = state;
        self._frames_in_episode = 0;
        self._last_step_seconds = 0.
        for declaration in self.players.values():
            if isinstance(declaration, Bot):
                declaration.on_match_start(state)
        return self._obs(state), self._info(state)

    def step(self, action: Optional[Union[int, dict[int, int]]] = None):
        started = perf_counter();
        bridge = self._connect();
        prev = self._last_state
        if prev is None:
            raise BridgeError("call reset() before step()")
        if self.lockstep and not self._lockstep_paused:
            raise BridgeError("lockstep environment is not paused; call reset()")
        masks = {}
        for player_id, declaration in self.players.items():
            if not isinstance(declaration, Bot):
                continue
            if isinstance(action, dict) and player_id in action:
                mask = ACTION_MASKS[int(action[player_id]) % len(ACTION_MASKS)]
            elif player_id == self.agent_player and action is not None:
                mask = ACTION_MASKS[int(action) % len(ACTION_MASKS)]
            else:
                mask = int(declaration.act(prev, player_id))
            masks[player_id] = mask;
            bridge.send_input(player_id, mask)
        self._last_masks = masks
        if self.lockstep:
            request = bridge.step_frame_sync() if self.lockstep_mode == "synchronous" else bridge.step_frame();
            state = reply_state(bridge.wait_reply(request, "step_complete", self.step_timeout), "step")
            if state.get("frame") != prev["frame"] + 1:
                raise BridgeError(f"lockstep step advanced from frame {prev['frame']} to {state.get('frame')}, expected {prev['frame'] + 1}")
            if not state.get("paused"):
                raise BridgeError("lockstep step completed without pausing the game")
            self._lockstep_paused = True
        else:
            state = bridge.wait_state(self.step_timeout, prev["frame"] + 1);
            self._dropped_frames += max(0, state["frame"] - prev["frame"] - 1)
        self._last_state = state;
        self._frames_in_episode += 1;
        self._last_step_seconds = perf_counter() - started
        return self._obs(state), self._reward(prev, state), bool(state["ended"]) or self._any_ko(state), self._frames_in_episode >= self.max_episode_frames, self._info(state)

    def run(self, #TODO: should this be strictly human-playable? or should this be able to switch between
            # 'rendering' mode and 'stepping' mode. What do I want this funciton to do? To be an interface
            # for playing against/vibe-checking my bots? I think so. If that's the case, should I make it
            # only human-playable and disable stepping mode?
            frames: Optional[int] = None,
            until_done: bool = False,
            record: bool = False) -> dict[int, list[dict]]:
        if frames is None and not until_done:
            raise ValueError("pass frames=N and/or until_done=True")

        slots = [pid for pid, declaration in self.players.items() if isinstance(declaration, Bot)];
        trajectory = {pid: [] for pid in slots} if record else {};
        count = 0
        while frames is None or count < frames:
            previous = self._last_state; _, _, terminated, truncated, _ = self.step()
            if record:
                for player_id in slots: trajectory[player_id].append({"state": previous, "obs": build_obs(previous, player_id), "mask": self._last_masks.get(player_id, 0), "reward": reward_delta(previous, self._last_state, player_id, self.ko_bonus)})
            count += 1
            if (terminated or truncated) and until_done: break
        print(f"run(): {count} frames, {self._dropped_frames} dropped"); return trajectory

    def record_human(self,
                     player_id: int,
                     frames: Optional[int] = None,
                     until_done: bool = True) -> list[tuple[int, int]]:
        if self.lockstep:
            raise BridgeError("record_human requires normal (non-lockstep) mode")
        if not isinstance(self.players.get(player_id), Human):
            raise ValueError(f"player {player_id} is not a Human declaration")
        previous = self._last_state
        if previous is None:
            raise BridgeError("call reset() before record_human()")

        script = [];
        mask = None;
        repeat = count = 0;
        bridge = self._connect()
        while frames is None or count < frames:
            state = bridge.wait_state(self.step_timeout, previous["frame"] + 1);
            previous = state;
            count += 1;
            character = next((char for char in state["chars"] if char["id"] == player_id), None);
            next_mask = character["controls"] if character else 0
            if next_mask != mask:
                if repeat: script.append((mask, repeat))
                mask, repeat = next_mask, 1
            else:
                repeat += 1
            if until_done and (state["ended"] or self._any_ko(state)):
                break
        if repeat:
            script.append((mask, repeat))
        self._last_state = previous;
        return script

    def collect_episode(self,
                        players: Optional[dict[int, Player]] = None,
                        stage: Optional[Union[str, Stage]] = None,
                        frames: Optional[int] = None,
                        until_done: bool = True) -> Episode:
        if players is not None or stage is not None:
            self.reset(players=players, stage=stage)
        bridge = self._connect();
        config = self.config or build_match_config(self.players, self.stage, self.lives);
        bridge.wait_reply(bridge.start_recording(), "ack", 5.);
        self.run(frames, until_done); bridge.wait_reply(bridge.stop_recording(), "ack", 5.);
        bridge.get_episode();
        event = bridge.wait_episode(30.)

        return Episode(event["frames"], config, event.get("generation", 0))

    def replay_ssfrec(self,
                      path: str,
                      collect: bool = True,
                      timeout: float = 30.) -> Episode:
        return replay_ssfrec(self, path, collect, timeout)

    def close(self) -> None:
        if self._bridge:
            if self.lockstep and self._lockstep_paused:
                try:
                    self._bridge.wait_reply(self._bridge.resume(), "ack", 1.)
                except BridgeError:
                    pass
            self._bridge.close();
            self._bridge = None
        self._lockstep_paused = False

    def describe_matchup(self) -> str:
        return describe_matchup(self.players, self.stage)

    def request_full_state(self, timeout: float = 5.) -> dict:
         return self._connect().request_full_state(timeout)

    def _chars(self, state: dict):
         return pick_chars(state, self.agent_player)

    @staticmethod
    def _validate_players(players: dict[int, Player], agent_player: int) -> None:
         validate_players(players, agent_player)

    @staticmethod
    def _reply_state(reply: dict, command: str) -> dict:
         return reply_state(reply, command)

    @staticmethod
    def _any_ko(state: dict) -> bool:
         return any(character["stocks"] <= 0 for character in state["chars"])

    def _obs(self, state: dict) -> np.ndarray:
         return build_obs(state, self.agent_player)

    def _reward(self, prev: dict, cur: dict) -> float:
         return reward_delta(prev, cur, self.agent_player, self.ko_bonus) * self.reward_scale

    def _info(self, state: dict) -> dict:
        me, opponent = self._chars(state)
        return {"frame": state["frame"],
                "paused": bool(state.get("paused")),
                "lockstep": self.lockstep,
                "lockstep_mode": self.lockstep_mode,
                "state_transport": self._bridge.state_transport if self._bridge else self.state_transport,
                "step_seconds": self._last_step_seconds,
                "simulation_fps": 1. / self._last_step_seconds if self._last_step_seconds else 0.,
                "me": me,
                "opp": opponent}

gym.register(id="SSF2-v0", entry_point="ssf2_rl.env:SSF2Env")
