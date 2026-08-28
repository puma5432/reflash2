"""SSF2 asset discovery and enum catalogues."""

from __future__ import annotations

from enum import Enum
from pathlib import Path

# .../reflash2/python/ssf2_rl/game/catalog.py -> repo root
_REPO_ROOT = Path(__file__).resolve().parents[3]
RANDOM = "random"


def _data_ids(subdir: str) -> frozenset[str]:
    directory = _REPO_ROOT / "build" / "data" / subdir
    if not directory.is_dir():
        return frozenset()
    return frozenset(path.stem for path in directory.glob("*.ssf"))


STAGES = _data_ids("stage") | {RANDOM}
CHARACTERS = _data_ids("character") | {RANDOM}


class Character(str, Enum):
    BandanaDee = "bandanadee"; BlackMage = "blackmage"; Bomberman = "bomberman"
    Bowser = "bowser"; CaptainFalcon = "captainfalcon"; ChibiRobo = "chibirobo"
    Dedede = "dedede"; DonkeyKong = "donkeykong"; Falco = "falco"; Fox = "fox"
    GameAndWatch = "gameandwatch"; Ganondorf = "ganondorf"; Goku = "goku"; Ichigo = "ichigo"
    Isaac = "isaac"; Jigglypuff = "jigglypuff"; Kirby = "kirby"; Krystal = "krystal"
    Link = "link"; Lloyd = "lloyd"; Lucario = "lucario"; Luffy = "luffy"; Luigi = "luigi"
    Mario = "mario"; Marth = "marth"; MegaMan = "megaman"; MetaKnight = "metaknight"
    Naruto = "naruto"; Ness = "ness"; PacMan = "pacman"; Peach = "peach"; Pichu = "pichu"
    Pikachu = "pikachu"; Pit = "pit"; Rayman = "rayman"; Ryu = "ryu"; Samus = "samus"
    Sandbag = "sandbag"; Simon = "simon"; Sonic = "sonic"; Sora = "sora"; Tails = "tails"
    Waluigi = "waluigi"; Wario = "wario"; Yoshi = "yoshi"; ZeroSuitSamus = "zamus"
    Zelda = "zelda"; Random = RANDOM


class Stage(str, Enum):
    Battlefield = "battlefield"; MMBattlefield = "battlefield2"; FinalDestination = "finaldestination"
    WaitingRoom = "waitingroom"; YoshisStory = "yoshisstory"; Warioware = "warioware"
    PokemonColosseum = "pokemoncolosseum"; DreamLand = "dreamland"; RainbowRoute = "rainbowroute"
    TowerOfSalvation = "towerofsalvation"; Smashville = "smashville"
    bf = "battlefield"; bf2 = "battlefield2"; fd = "finaldestination"; wr = "waitingroom"
    ys = "yoshisstory"; ww = "warioware"; pc = "pokemoncolosseum"; dl = "dreamland"
    rr = "rainbowroute"; tos = "towerofsalvation"; sv = "smashville"; Random = RANDOM
