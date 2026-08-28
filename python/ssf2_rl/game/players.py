"""Player-slot declarations and match configuration."""

from __future__ import annotations

import abc
from typing import Optional, Union

from .catalog import CHARACTERS, RANDOM, STAGES, Character, Stage

CharLike = Union[Character, str, None]
StageLike = Union[Stage, str]


def _char_id(character: CharLike) -> Optional[str]:
    return character.value if isinstance(character, Character) else (str(character) if character is not None else None)


def _stage_id(stage: StageLike) -> str:
    return stage.value if isinstance(stage, Stage) else str(stage)


class Player(abc.ABC):
    """Declares who occupies one player slot."""

    def __init__(self, character: CharLike = None) -> None:
        char = _char_id(character)
        if char is not None and char not in CHARACTERS:
            raise ValueError(f"unknown character {char!r}; valid: {sorted(CHARACTERS - {RANDOM})} or {RANDOM!r}")
        self.character = char

    @abc.abstractmethod
    def describe(self) -> str:
        """One-line human-readable description of this slot's controller."""

    def __repr__(self) -> str:
        return f"{type(self).__name__}({self.describe()})"


class Human(Player):
    """A physical controller which is never taken over by Python."""

    def describe(self) -> str:
        return f"human, character={self.character or 'default'}"


class CPU(Player):
    """The in-game AI at a given level, never driven by Python."""

    def __init__(self, character: CharLike = None, level: int = 9) -> None:
        super().__init__(character)
        if not 0 <= int(level) <= 9:
            raise ValueError(f"CPU level must be 0..9, got {level}")
        self.level = int(level)

    def describe(self) -> str:
        return f"in-game CPU level {self.level}, character={self.character or 'default'}"


def build_match_config(players: dict[int, Player], stage: StageLike = "finaldestination", lives: int = 99, using_time: bool = False, time: int = 99) -> dict:
    """Build the restart-match JSON consumed by the game bridge."""
    if len(players) < 2:
        raise ValueError("a match needs at least 2 players")
    ids = sorted(players)
    if ids != list(range(1, len(ids) + 1)):
        raise ValueError(f"player ids must be contiguous from 1, got {ids}")
    stage_id = _stage_id(stage)
    if stage_id not in STAGES:
        raise ValueError(f"unknown stage {stage_id!r}; valid: {sorted(STAGES - {RANDOM})} or {RANDOM!r}")
    cpu_levels = [player.level for player in players.values() if isinstance(player, CPU)]
    return {
        "stage": stage_id,
        "characters": [players[player_id].character or RANDOM for player_id in ids],
        "lives": int(lives),
        "cpuLevel": max(cpu_levels) if cpu_levels else 9,
        "usingTime": bool(using_time),
        "time": int(time),
    }


def describe_matchup(players: dict[int, Player], stage: Optional[StageLike] = None) -> str:
    lines = [f"stage: {_stage_id(stage)}"] if stage else []
    lines.extend(f"P{player_id}: {players[player_id].describe()}" for player_id in sorted(players))
    return "\n".join(lines)
