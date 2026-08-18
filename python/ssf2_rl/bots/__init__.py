"""Pluggable control sources for SSF2 player slots (Slippi-AI style).

A *bot* is a ``Player`` declaration that carries its own per-frame behavior:
``act(state, me_id) -> controls mask``. ``SSF2Env`` takes over every bot
slot and drives it each frame; ``Human``/``CPU`` slots keep their native
control source and need no Python code.

Bot types:
    ``Agent``       the step-driven RL slot (``env.step(action)`` supplies masks)
    ``ZeroBot``     always sends no input (stand still)
    ``FollowBot``   walks toward the opponent (observation sanity check)
    ``ScriptedBot`` plays a fixed ``(mask, frames)`` sequence of controls masks
    ``PolicyBot``   wraps any callable obs -> action (neural nets / RL)
"""

from .base import Agent, Bot, FollowBot, ZeroBot
from .scripted import ScriptedBot
from .policy import PolicyBot

__all__ = [
    "Bot",
    "Agent",
    "ZeroBot",
    "FollowBot",
    "ScriptedBot",
    "PolicyBot",
]
