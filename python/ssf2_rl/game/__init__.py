"""SSF2 game integration: assets, players, controls, and launcher."""
from .catalog import CHARACTERS, RANDOM, STAGES, Character, Stage
from .players import CPU, Human, Player, build_match_config, describe_matchup
__all__ = ["CHARACTERS", "RANDOM", "STAGES", "CPU", "Character", "Human", "Player", "Stage", "build_match_config", "describe_matchup"]
