"""SSF2 RL research bridge client.

Talks to the instrumented ReFlash2 research build over a loopback TCP socket
(newline-delimited JSON). The game streams one state snapshot per simulation
frame (30 FPS) and accepts one-frame input masks for CPU-controlled characters.
"""

from .actions import ACTION_TABLE, ACTION_NAMES, ACTION_MASKS, action_index
from .bridge import SSF2Bridge, BridgeError
from .controls import Controls, BITS, bit_name_map, describe_mask
from .launcher import (
    LaunchError,
    ensure_game_running,
    game_log_path,
    port_open,
    stop_game,
)
from .players import (
    CHARACTERS,
    STAGES,
    CPU,
    Human,
    Player,
    build_match_config,
    describe_matchup,
)
from .bots import Agent, Bot, FollowBot, PolicyBot, ScriptedBot, ZeroBot
from .obs import (
    CHAR_FEATURES,
    OBS_DIM,
    build_obs,
    char_vec,
    obs_feature_names,
    pick_chars,
    reward_delta,
)

__all__ = [
    "SSF2Bridge",
    "BridgeError",
    "Controls",
    "BITS",
    "bit_name_map",
    "describe_mask",
    "LaunchError",
    "ensure_game_running",
    "game_log_path",
    "port_open",
    "stop_game",
    "CHARACTERS",
    "STAGES",
    "CPU",
    "Human",
    "Player",
    "build_match_config",
    "describe_matchup",
    "Agent",
    "Bot",
    "FollowBot",
    "PolicyBot",
    "ScriptedBot",
    "ZeroBot",
    "ACTION_TABLE",
    "ACTION_NAMES",
    "ACTION_MASKS",
    "action_index",
    "CHAR_FEATURES",
    "OBS_DIM",
    "build_obs",
    "char_vec",
    "obs_feature_names",
    "pick_chars",
    "reward_delta",
]
