"""Policy-backed bot declarations."""

from __future__ import annotations
from typing import Callable, Union
import numpy as np
from ..actions import ACTION_MASKS, ACTION_NAMES
from ..observation import build_obs
from ...game.players import CharLike
from .base import Bot

Policy = Callable[[np.ndarray], Union[int, str, np.integer]]


class PolicyBot(Bot):
    def __init__(self, character: CharLike = None, policy: Policy = None, name: str = "policy") -> None:
        super().__init__(character)
        if policy is None:
            raise ValueError("PolicyBot requires a policy=")
        self._policy, self.name = policy, name

    def act(self, state: dict, me_id: int) -> int:
        action = self._policy(build_obs(state, me_id))
        if isinstance(action, str):
            if action not in ACTION_NAMES:
                raise ValueError(f"policy returned unknown action {action!r}")
            return ACTION_MASKS[ACTION_NAMES.index(action)]
        index = int(action)
        if not 0 <= index < len(ACTION_MASKS):
            raise ValueError(f"policy returned out-of-range action index {index} (valid: 0..{len(ACTION_MASKS) - 1})")
        return ACTION_MASKS[index]
