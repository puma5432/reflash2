"""Pluggable control sources for SSF2 player slots (Slippi-AI style).

A *bot* is anything that turns a game state snapshot into one frame of held
input (a controls bit mask). ``BotRunner`` takes over a set of slots and
drives them frame-by-frame over the research bridge; any slot left out of
the runner keeps its native control source (in-game CPU AI or human).

Bot types:
    ``ZeroBot``     always sends no input (stand still)
    ``ScriptedBot`` plays a fixed ``(action_name, frames)`` sequence
    ``PolicyBot``   wraps any callable obs -> action (neural nets / RL)
"""

from .base import Bot, ZeroBot, BotRunner
from .scripted import ScriptedBot
from .policy import PolicyBot

__all__ = [
    "Bot",
    "ZeroBot",
    "ScriptedBot",
    "PolicyBot",
    "BotRunner",
]
