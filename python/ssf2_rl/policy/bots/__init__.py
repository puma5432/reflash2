"""Pluggable Python control sources for SSF2 player slots."""
from .base import Agent, Bot, ZeroBot
from .heuristic import FollowBot
from .policy import Policy, PolicyBot
from .scripted import ScriptedBot, load_recording, save_recording

__all__ = ["Agent", "Bot", "FollowBot", "Policy", "PolicyBot", "ScriptedBot", "ZeroBot", "load_recording", "save_recording"]
