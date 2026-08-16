"""Bot base classes: a Bot IS a player declaration with behavior.

Design mirrors Slippi AI but collapses it into one hierarchy: every slot in
a matchup is a ``Player`` (see ``ssf2_rl.players``), and a ``Bot`` is a
``Player`` that the bridge takes over and drives from Python. The single
behavior method is ``act(state, me_id) -> controls mask``; its default
returns 0 (hold nothing), so a taken-over slot never silently reverts to
the in-game CPU and subclasses inherit a safe, observable noop.

``Agent`` marks the slot driven by ``SSF2Env.step(action)`` (the RL
training path); ``ZeroBot``/``FollowBot`` live here, ``ScriptedBot`` and
``PolicyBot`` in sibling modules.
"""

from __future__ import annotations

from typing import Optional

from ..actions import ACTION_MASKS, action_index
from ..obs import pick_chars
from ..players import Player


class Bot(Player):
    """A Python-driven player slot.

    ``act`` receives the latest raw bridge state snapshot and the player id
    of the slot it controls, and returns one frame of held input as a
    controls bit mask (see ``ssf2_rl.controls``).

    The default ``act`` returns 0 (hold nothing): subclasses inherit a safe,
    observable noop instead of being forced to implement it. Subclasses that
    only act in specific situations can ``return super().act(state, me_id)``
    to explicitly fall back to noop.
    """

    #: Optional human-readable name (used in logs / trajectory keys).
    name: str = "bot"

    def on_match_start(self, state: dict) -> None:
        """Hook called once after the env (re)starts a match."""

    def act(self, state: dict, me_id: int) -> int:
        """Return the controls mask to hold for the next frame.

        Default: no input (mask 0). Override to add behavior.
        """
        return 0

    def reset(self) -> None:
        """Hook called before each new match; default is a no-op."""

    def describe(self) -> str:
        char = self.character or "default"
        return f"Python {type(self).__name__} ({self.name}), character={char}"


class Agent(Bot):
    """The step-driven slot: ``SSF2Env.step(action)`` supplies its masks.

    This is the RL training path — the policy/algorithm lives in your code,
    not in a bot object. ``act`` still returns 0 as a fallback for frames
    with no explicit action (e.g. ``env.step()`` during evaluation).
    """

    name = "agent"

    def describe(self) -> str:
        char = self.character or "default"
        return f"external agent (step-driven), character={char}"


class ZeroBot(Bot):
    """Always sends no input. Useful as a stand-still opponent/agent.

    This is exactly the inherited default behavior; the class exists so
    matchups read clearly ("P2: Python ZeroBot").
    """

    name = "zero"

class FollowBot(Bot):
    """Walk left/right toward the opponent, stopping inside a deadzone.

    A living check that the bridge state is being read correctly: if this
    bot visibly chases the other character around the stage, the x/dx data
    in the snapshots (and therefore the observations built from them) is
    trustworthy.
    """

    name = "follow"

    def __init__(self, character: Optional[str] = None, deadzone: float = 30.0) -> None:
        super().__init__(character)
        if deadzone < 0:
            raise ValueError("deadzone must be >= 0")
        self.deadzone = float(deadzone)

    def act(self, state: dict, me_id: int) -> int:
        me, opp = pick_chars(state, me_id)
        if me is None or opp is None:
            return super().act(state, me_id)  # explicit noop fallback
        dx = opp["x"] - me["x"]
        if abs(dx) < self.deadzone:
            return 0
        return ACTION_MASKS[action_index("right" if dx > 0 else "left")]
