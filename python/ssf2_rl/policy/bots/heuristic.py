"""Small deterministic heuristic bots."""

from ..actions import ACTION_MASKS, action_index
from ..observation import pick_chars
from ...game.players import CharLike
from .base import Bot


class FollowBot(Bot):
    """Walk toward the opponent, stopping within ``deadzone``."""
    name = "follow"

    def __init__(self, character: CharLike = None, deadzone: float = 30.0) -> None:
        super().__init__(character)
        if deadzone < 0:
            raise ValueError("deadzone must be >= 0")
        self.deadzone = float(deadzone)

    def act(self, state: dict, me_id: int) -> int:
        me, opponent = pick_chars(state, me_id)
        if me is None or opponent is None:
            return super().act(state, me_id)
        dx = opponent["x"] - me["x"]
        return 0 if abs(dx) < self.deadzone else ACTION_MASKS[action_index("right" if dx > 0 else "left")]
