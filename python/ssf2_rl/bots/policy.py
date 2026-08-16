"""Neural-net / RL-ready bot: wraps any callable ``obs -> action``.

``PolicyBot`` keeps the bot interface identical to ``ScriptedBot`` and
``ZeroBot``; the only difference is where the decision comes from. Today the
policy can be a trivial numpy function; later it can be a ``torch.nn.Module``
without any change to the runner or the rest of the codebase. Torch is an
optional dependency — any callable works.
"""

from __future__ import annotations

from typing import Callable, Optional, Union

import numpy as np

from ..actions import ACTION_NAMES, ACTION_MASKS
from ..obs import build_obs
from .base import Bot

#: A policy maps the 38-dim obs vector to an action index or action name.
Policy = Callable[[np.ndarray], Union[int, str, np.integer]]


class PolicyBot(Bot):
    """Drives a slot with a learned (or hand-written) policy function.

    Args:
        policy: callable taking the 38-dim float32 observation (see
            ``ssf2_rl.obs.build_obs``) and returning either an action index
            into ``ACTION_NAMES`` or an action name string.
        name: label used in logs / trajectory keys.

    Example (random policy)::

        PolicyBot("marth", lambda obs: np.random.randint(len(ACTION_NAMES)))

    Example (torch, later)::

        net = torch.load("policy.pt")
        PolicyBot("marth", lambda obs: int(net(torch.from_numpy(obs)).argmax()))
    """

    def __init__(self, character: Optional[str] = None, policy: Policy = None, name: str = "policy") -> None:
        super().__init__(character)
        if policy is None:
            raise ValueError("PolicyBot requires a policy=")
        self._policy = policy
        self.name = name

    def act(self, state: dict, me_id: int) -> int:
        obs = build_obs(state, me_id)
        action = self._policy(obs)
        if isinstance(action, str):
            if action not in ACTION_NAMES:
                raise ValueError(f"policy returned unknown action {action!r}")
            return ACTION_MASKS[ACTION_NAMES.index(action)]
        idx = int(action)
        if not 0 <= idx < len(ACTION_MASKS):
            raise ValueError(
                f"policy returned out-of-range action index {idx} "
                f"(valid: 0..{len(ACTION_MASKS) - 1})"
            )
        return ACTION_MASKS[idx]
