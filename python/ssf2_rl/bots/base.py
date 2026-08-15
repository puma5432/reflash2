"""Bot interface and the frame-loop driver (``BotRunner``).

Design mirrors Slippi AI: every control source implements one method —
``act(state, me_id) -> controls mask`` — and a runner feeds it game frames.
Slots not handed to the runner keep their native control source (in-game
CPU AI or human player), so "CPU" and "player" need no Python code.
"""

from __future__ import annotations

import time
from abc import ABC, abstractmethod
from typing import Any, Optional

from ..bridge import SSF2Bridge, BridgeError
from ..launcher import ensure_game_running
from ..obs import build_obs, pick_chars, reward_delta

DEFAULT_HOST = "127.0.0.1"
DEFAULT_PORT = 4567


class Bot(ABC):
    """A control source for one player slot.

    ``act`` receives the latest raw bridge state snapshot and the player id
    of the slot it controls, and returns one frame of held input as a
    controls bit mask (see ``ssf2_rl.controls``).
    """

    #: Optional human-readable name (used in logs / trajectory keys).
    name: str = "bot"

    def on_match_start(self, state: dict) -> None:
        """Hook called once after the runner (re)starts a match."""

    @abstractmethod
    def act(self, state: dict, me_id: int) -> int:
        """Return the controls mask to hold for the next frame."""

    def reset(self) -> None:
        """Hook called before each new match; default is a no-op."""


class ZeroBot(Bot):
    """Always sends no input. Useful as a stand-still opponent/agent."""

    name = "zero"

    def act(self, state: dict, me_id: int) -> int:
        return 0


class BotRunner:
    """Drives one bot per controlled slot, frame-by-frame, over the bridge.

    Slots absent from ``bots`` are left untouched: the in-game CPU AI (or a
    human) keeps controlling them. This is how you express matchups like
    "scripted Marth vs native CPU Samus" or "policy vs zero bot".

    Example::

        runner = BotRunner(bots={1: ScriptedBot(script), 2: ZeroBot()})
        runner.start()
        traj = runner.run(frames=900, record=True)
        runner.close()
    """

    def __init__(
        self,
        bots: dict[int, Bot],
        host: str = DEFAULT_HOST,
        port: int = DEFAULT_PORT,
        config: Optional[dict] = None,
        step_timeout: float = 2.0,
        ko_bonus: float = 10.0,
        auto_launch: bool = True,
    ) -> None:
        if not bots:
            raise ValueError("BotRunner needs at least one bot; "
                             "uncontrolled slots stay native CPU/human")
        self.bots = dict(bots)
        self._host = host
        self._port = port
        self.auto_launch = auto_launch
        self.config = config
        self.step_timeout = step_timeout
        self.ko_bonus = ko_bonus
        self._bridge: Optional[SSF2Bridge] = None
        self._last_state: Optional[dict] = None

    # -- lifecycle -----------------------------------------------------------

    @property
    def bridge(self) -> SSF2Bridge:
        if self._bridge is None:
            raise BridgeError("runner not started; call start() first")
        return self._bridge

    def start(self) -> dict:
        """Connect, restart the match, and take over the controlled slots.

        Returns the first state snapshot of the fresh match.
        """
        if self._bridge is None:
            if self.auto_launch:
                # Start the game if it isn't running yet; no-op otherwise.
                ensure_game_running(self._host, self._port)
            self._bridge = SSF2Bridge(self._host, self._port, timeout=15.0)
            self._bridge.connect()
        bridge = self._bridge
        bridge.restart_match(self.config)
        state = self._wait_for_new_match(bridge)
        for player in self.bots:
            bridge.takeover(player)
        self._last_state = state
        for bot in self.bots.values():
            bot.reset()
            bot.on_match_start(state)
        return state

    def close(self) -> None:
        if self._bridge is not None:
            self._bridge.close()
            self._bridge = None
        self._last_state = None

    def __enter__(self) -> "BotRunner":
        self.start()
        return self

    def __exit__(self, *_: object) -> None:
        self.close()

    # -- frame loop ------------------------------------------------------------

    def step(self) -> tuple[dict, bool, dict[int, int]]:
        """Advance exactly one game frame: query each bot, send its mask.

        Returns ``(state, ended, masks)`` where ``state`` is the snapshot
        after the frame, ``ended`` is True if the match has ended or someone
        was KOd, and ``masks`` maps player id -> mask sent this frame.
        """
        bridge = self.bridge
        prev = self._last_state
        if prev is None:
            raise BridgeError("runner not started; call start() first")
        masks: dict[int, int] = {}
        for player, bot in self.bots.items():
            mask = int(bot.act(prev, player))
            masks[player] = mask
            bridge.send_input(player, mask)
        state = bridge.wait_state(timeout=self.step_timeout, min_frame=prev["frame"] + 1)
        self._last_state = state
        ended = bool(state["ended"]) or any(c["stocks"] <= 0 for c in state["chars"])
        return state, ended, masks

    def run(
        self,
        frames: Optional[int] = None,
        until_done: bool = False,
        record: bool = False,
    ) -> dict[int, list[dict]]:
        """Run the frame loop.

        Args:
            frames: maximum number of frames to run (None = unlimited).
            until_done: also stop early when the match ends / a stock hits 0.
            record: collect per-slot trajectory dicts
                (``state``, ``obs``, ``mask``, ``reward``) for each frame.

        Returns:
            ``{player_id: [frame records]}`` when ``record`` else ``{}``.
        """
        if frames is None and not until_done:
            raise ValueError("pass frames=N and/or until_done=True")
        traj: dict[int, list[dict]] = {p: [] for p in self.bots} if record else {}
        n = 0
        while frames is None or n < frames:
            prev = self._last_state
            state, ended, masks = self.step()
            if record:
                for player in self.bots:
                    traj[player].append({
                        "state": prev,
                        "obs": build_obs(prev, player),
                        "mask": masks[player],
                        "reward": reward_delta(prev, state, player, ko_bonus=self.ko_bonus),
                    })
            n += 1
            if ended and until_done:
                break
        return traj

    # -- helpers ---------------------------------------------------------------

    def _wait_for_new_match(self, bridge: SSF2Bridge) -> dict:
        """After restart_match, wait until the frame counter drops (new match)."""
        deadline = time.monotonic() + 20.0
        first = bridge.wait_state(timeout=10.0)
        while time.monotonic() < deadline:
            s = bridge.wait_state(timeout=5.0)
            if s["frame"] < first["frame"] or s["frame"] < 90:
                return s
        return bridge.wait_state(timeout=5.0)

    def latest_state(self) -> Optional[dict]:
        return self._last_state
