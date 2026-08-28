"""Shared normalized 38-dimensional observation construction."""

from __future__ import annotations

import math
from typing import Optional
import numpy as np

_POS, _VEL, _DMG = 400.0, 25.0, 300.0
CHAR_FEATURES = ["x", "y", "nxs", "nys", "facing", "damage", "stocks", "ground", "jumpCount", "shieldPower", "shielding", "hitstun", "attacking", "atkExec", "hanging", "dead"]
OBS_DIM = 2 * len(CHAR_FEATURES) + 6


def norm(value: float, scale: float) -> float:
    return max(-1.0, min(1.0, float(value) / scale))


def obs_feature_names() -> list[str]:
    return [f"me_{feature}" for feature in CHAR_FEATURES] + [f"opp_{feature}" for feature in CHAR_FEATURES] + ["rel_dx", "rel_dy", "rel_dist", "facing_align", "frame", "paused"]


def chars_by_id(state: dict) -> dict[int, dict]:
    return {character["id"]: character for character in state["chars"]}


def pick_chars(state: dict, me_id: int) -> tuple[Optional[dict], Optional[dict]]:
    chars = chars_by_id(state)
    me = chars.get(me_id)
    opponent_id = next((character_id for character_id in chars if character_id != me_id), None)
    return me, chars.get(opponent_id)


def char_vec(character: dict) -> list[float]:
    return [norm(character["x"], _POS), norm(character["y"], _POS), norm(character["nxs"], _VEL), norm(character["nys"], _VEL), 1.0 if character["facing"] else -1.0, norm(character["damage"], _DMG), norm(character["stocks"], 5.0), 1.0 if character["ground"] else -1.0, norm(character["jumpCount"], 3.0), norm(character["shieldPower"], 100.0), 1.0 if character["shielding"] else -1.0, 1.0 if character["hitstun"] else -1.0, 1.0 if character["atkFrame"] else -1.0, norm(character["atkExec"], 60.0), 1.0 if character["hanging"] else -1.0, 1.0 if character["dead"] else -1.0]


def build_obs(state: dict, me_id: int) -> np.ndarray:
    me, opponent = pick_chars(state, me_id)
    if me is None or opponent is None:
        return np.zeros((OBS_DIM,), dtype=np.float32)
    dx, dy = opponent["x"] - me["x"], opponent["y"] - me["y"]
    values = char_vec(me) + char_vec(opponent) + [norm(dx, _POS), norm(dy, _POS), norm(math.sqrt(dx * dx + dy * dy), _POS), 1.0 if (dx >= 0) == bool(me["facing"]) else -1.0, norm(state["frame"], 1e5), 1.0 if state["paused"] else -1.0]
    return np.asarray(values, dtype=np.float32)
