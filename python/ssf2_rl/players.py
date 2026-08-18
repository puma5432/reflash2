"""Slippi-style player slot declarations for SSF2.

A ``Player`` declares WHO occupies a slot. Three kinds:

- ``Human``  — a physical controller; never taken over.
- ``CPU``    — the in-game AI at a level; never driven by Python.
- ``Bot``    — taken over by the bridge and driven from Python. Bots ARE
  their declaration (see ``ssf2_rl.bots``): ``FollowBot(Character.Samus)``,
  ``ScriptedBot(Character.Marth, script)``, ``ZeroBot(Character.Samus)``, or
  ``Agent(Character.Marth)`` for the step-driven RL slot.

Unlike Slippi there is no "menuing" branch: SSF2 matches are configured via
the restart-match JSON (see ``rlStartVSMatch`` in tools/rl/ModAPI_patched.as),
so declarations translate directly into that config via ``build_match_config``.

Example::

    players = {
        1: ScriptedBot(Character.Marth, script),
        2: CPU(Character.Samus, level=0),
    }
    config = build_match_config(players, stage=Stage.Battlefield)

Plain strings (``"marth"``, ``"battlefield"``) are still accepted wherever
an enum member is.
"""

from __future__ import annotations

import abc
from enum import Enum
from pathlib import Path
from typing import Optional, Union

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


class Character(str, Enum):
    """Playable characters (values are the build/data/character/*.ssf ids).

    Every id in ``CHARACTERS`` has a member; ``Character.Random`` maps to
    the game-side random pick. Plain strings are still accepted wherever a
    ``Character`` is.
    """

    BandanaDee = "bandanadee"
    BlackMage = "blackmage"
    Bomberman = "bomberman"
    Bowser = "bowser"
    CaptainFalcon = "captainfalcon"
    ChibiRobo = "chibirobo"
    Dedede = "dedede"
    DonkeyKong = "donkeykong"
    Falco = "falco"
    Fox = "fox"
    GameAndWatch = "gameandwatch"
    Ganondorf = "ganondorf"
    Goku = "goku"
    Ichigo = "ichigo"
    Isaac = "isaac"
    Jigglypuff = "jigglypuff"
    Kirby = "kirby"
    Krystal = "krystal"
    Link = "link"
    Lloyd = "lloyd"
    Lucario = "lucario"
    Luffy = "luffy"
    Luigi = "luigi"
    Mario = "mario"
    Marth = "marth"
    MegaMan = "megaman"
    MetaKnight = "metaknight"
    Naruto = "naruto"
    Ness = "ness"
    PacMan = "pacman"
    Peach = "peach"
    Pichu = "pichu"
    Pikachu = "pikachu"
    Pit = "pit"
    Rayman = "rayman"
    Ryu = "ryu"
    Samus = "samus"
    Sandbag = "sandbag"
    Simon = "simon"
    Sonic = "sonic"
    Sora = "sora"
    Tails = "tails"
    Waluigi = "waluigi"
    Wario = "wario"
    Yoshi = "yoshi"
    ZeroSuitSamus = "zamus"
    Zelda = "zelda"
    Random = RANDOM


class Stage(str, Enum):
    """Curated stage picks for research matches (values are data ids).

    Only the stages commonly used for experiments are members; any other id
    in ``STAGES`` can still be passed as a plain string. ``Stage.Random``
    maps to the game-side random pick.
    """

    Battlefield = "battlefield"
    MMBattlefield = "battlefield2"  # Multi-Man Battlefield
    FinalDestination = "finaldestination"
    WaitingRoom = "waitingroom"
    YoshisStory = "yoshisstory"
    Warioware = "warioware"
    PokemonColosseum = "pokemoncolosseum"
    DreamLand = "dreamland"
    RainbowRoute = "rainbowroute"
    TowerOfSalvation = "towerofsalvation"
    Smashville = "smashville"

    bf = "battlefield"
    bf2 = "battlefield2"  # Multi-Man Battlefield
    fd = "finaldestination"
    wr = "waitingroom"
    ys = "yoshisstory"
    ww = "warioware"
    pc = "pokemoncolosseum"
    dl = "dreamland"
    rr = "rainbowroute"
    tos = "towerofsalvation"
    sv = "smashville"

    Random = RANDOM


#: What a character declaration accepts: enum member, raw id, or None.
CharLike = Union[Character, str, None]
#: What a stage declaration accepts: enum member or raw id.
StageLike = Union[Stage, str]


def _char_id(character: CharLike) -> Optional[str]:
    """Normalize a character declaration to its raw data id (or None)."""
    if character is None:
        return None
    return character.value if isinstance(character, Character) else str(character)


def _stage_id(stage: StageLike) -> str:
    """Normalize a stage declaration to its raw data id."""
    return stage.value if isinstance(stage, Stage) else str(stage)


class Player(abc.ABC):
    """Declares who occupies one player slot."""

    def __init__(self, character: CharLike = None) -> None:
        char = _char_id(character)
        if char is not None and char not in CHARACTERS:
            raise ValueError(
                f"unknown character {char!r}; "
                f"valid: {sorted(CHARACTERS - {RANDOM})} or {RANDOM!r}"
            )
        self.character = char

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

    def __init__(self, character: CharLike = None, level: int = 9) -> None:
        super().__init__(character)
        if not 0 <= int(level) <= 9:
            raise ValueError(f"CPU level must be 0..9, got {level}")
        self.level = int(level)

    def describe(self) -> str:
        char = self.character or "default"
        return f"in-game CPU level {self.level}, character={char}"


def build_match_config(
    players: dict[int, Player],
    stage: StageLike = "finaldestination",
    lives: int = 99,
    using_time: bool = False,
    time: int = 99,
) -> dict:
    """Build the restart-match JSON expected by ``rlStartVSMatch``.

    Args:
        players: slot id (1-based) -> declaration. Must cover slots 1..N
            contiguously with at least 2 entries.
        stage: stage id or ``Stage`` member (see ``STAGES``).
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
    stage = _stage_id(stage)
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


def describe_matchup(players: dict[int, Player], stage: Optional[StageLike] = None) -> str:
    """One-table summary of who controls every slot."""
    lines = []
    if stage:
        lines.append(f"stage: {_stage_id(stage)}")
    for pid in sorted(players):
        lines.append(f"P{pid}: {players[pid].describe()}")
    return "\n".join(lines)
