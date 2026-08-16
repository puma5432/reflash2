"""Slippi-style player slot declarations for SSF2.

A ``Player`` declares WHO occupies a slot. Three kinds:

- ``Human``  — a physical controller; never taken over.
- ``CPU``    — the in-game AI at a level; never driven by Python.
- ``Bot``    — taken over by the bridge and driven from Python. Bots ARE
  their declaration (see ``ssf2_rl.bots``): ``FollowBot("samus")`,
  ``ScriptedBot("marth", script)``, ``ZeroBot("samus")``, or ``Agent("marth")``
  for the step-driven RL slot.

Unlike Slippi there is no "menuing" branch: SSF2 matches are configured via
the restart-match JSON (see ``rlStartVSMatch`` in tools/rl/ModAPI_patched.as),
so declarations translate directly into that config via ``build_match_config``.

Example::

    players = {
        1: ScriptedBot("marth", script),
        2: CPU("samus", level=0),
    }
    config = build_match_config(players, stage="battlefield")
"""

from __future__ import annotations

import abc
from pathlib import Path
from typing import Optional

# Repo root: .../reflash2/python/ssf2_rl/players.py -> parents[2]
_REPO_ROOT = Path(__file__).resolve().parents[2]

RANDOM = "random"  # supported game-side for both stage and character


def _data_ids(subdir: str) -> frozenset[str]:
    """Valid ids from build/data/<subdir>/*.ssf filenames."""
    d = _REPO_ROOT / "build" / "data" / subdir
    if not d.is_dir():
        return frozenset()
    return frozenset(p.stem for p in d.glob("*.ssf"))


#: Valid stage ids (from build/data/stage/), plus "random".
STAGES: frozenset[str] = _data_ids("stage") | {RANDOM}

#: Valid character ids (from build/data/character/), plus "random".
CHARACTERS: frozenset[str] = _data_ids("character") | {RANDOM}


class Player(abc.ABC):
    """Declares who occupies one player slot."""

    def __init__(self, character: Optional[str] = None) -> None:
        if character is not None and character not in CHARACTERS:
            raise ValueError(
                f"unknown character {character!r}; "
                f"valid: {sorted(CHARACTERS - {RANDOM})} or {RANDOM!r}"
            )
        self.character = character

    @abc.abstractmethod
    def describe(self) -> str:
        """One-line human-readable description of this slot's controller."""

    def __repr__(self) -> str:
        return f"{type(self).__name__}({self.describe()})"


class Human(Player):
    """A physical controller. Never taken over; no Python frames are sent."""

    def describe(self) -> str:
        char = self.character or "default"
        return f"human, character={char}"


class CPU(Player):
    """The in-game AI at the given level. Never taken over.

    Note: the current game build applies a single ``cpuLevel`` to every
    non-P1 slot, so per-slot levels only take effect for slot > 1 when all
    CPUs share the same level (see rlStartVSMatch).
    """

    def __init__(self, character: Optional[str] = None, level: int = 9) -> None:
        super().__init__(character)
        if not 0 <= int(level) <= 9:
            raise ValueError(f"CPU level must be 0..9, got {level}")
        self.level = int(level)

    def describe(self) -> str:
        char = self.character or "default"
        return f"in-game CPU level {self.level}, character={char}"


def build_match_config(
    players: dict[int, Player],
    stage: str = "finaldestination",
    lives: int = 99,
    using_time: bool = False,
    time: int = 99,
) -> dict:
    """Build the restart-match JSON expected by ``rlStartVSMatch``.

    Args:
        players: slot id (1-based) -> declaration. Must cover slots 1..N
            contiguously with at least 2 entries.
        stage: stage id (see ``STAGES``).
        lives: stock count.
        using_time / time: match timer.

    Returns:
        dict with keys ``stage``, ``characters``, ``lives``, ``cpuLevel``,
        ``usingTime``, ``time``.
    """
    if len(players) < 2:
        raise ValueError("a match needs at least 2 players")
    ids = sorted(players)
    if ids != list(range(1, len(ids) + 1)):
        raise ValueError(f"player ids must be contiguous from 1, got {ids}")
    if stage not in STAGES:
        raise ValueError(
            f"unknown stage {stage!r}; valid: {sorted(STAGES - {RANDOM})} or {RANDOM!r}"
        )

    characters = [players[i].character or "random" for i in ids]
    # The game applies one cpuLevel to all non-P1 slots; use the max level
    # requested so no CPU is accidentally weakened/strengthened.
    cpu_levels = [p.level for p in players.values() if isinstance(p, CPU)]
    cpu_level = max(cpu_levels) if cpu_levels else 9

    return {
        "stage": stage,
        "characters": characters,
        "lives": int(lives),
        "cpuLevel": int(cpu_level),
        "usingTime": bool(using_time),
        "time": int(time),
    }


def describe_matchup(players: dict[int, Player], stage: Optional[str] = None) -> str:
    """One-table summary of who controls every slot."""
    lines = []
    if stage:
        lines.append(f"stage: {stage}")
    for pid in sorted(players):
        lines.append(f"P{pid}: {players[pid].describe()}")
    return "\n".join(lines)
