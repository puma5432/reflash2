"""Base bot/player declarations."""

from __future__ import annotations
from ...game.players import Player


class Bot(Player):
    name = "bot"

    def on_match_start(self, state: dict) -> None:
        pass

    def act(self, state: dict, me_id: int) -> int:
        return 0

    def reset(self) -> None:
        pass

    def describe(self) -> str:
        return f"Python {type(self).__name__} ({self.name}), character={self.character or 'default'}"


class Agent(Bot):
    name = "agent"

    def describe(self) -> str:
        return f"external agent (step-driven), character={self.character or 'default'}"


class ZeroBot(Bot):
    name = "zero"
