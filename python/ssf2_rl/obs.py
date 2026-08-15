"""Shared observation construction for the SSF2 research bridge.

Both the Gymnasium environment (``SSF2Env``) and the standalone bot layer
(``ssf2_rl.bots``) build the same 38-dim float32 observation vector from a
raw bridge state snapshot, so policies see identical inputs regardless of
which driver is running them.

Layout: agent char features (16) + opponent char features (16) + relative
features (4) + match features (2). See ``obs_feature_names()``.
"""

from __future__ import annotations

import math
from typing import Any, Optional

import numpy as np

# Normalization constants (stage coords are roughly +/- 300 x, +/- 250 y;
# speeds ~ +/- 20; damage 0-999; shield 0-100).
_POS = 400.0
_VEL = 25.0
_DMG = 300.0

# Per-character feature layout (mirrors char_vec ordering).
CHAR_FEATURES = [
    "x", "y", "nxs", "nys", "facing", "damage", "stocks", "ground",
    "jumpCount", "shieldPower", "shielding", "hitstun", "attacking",
    "atkExec", "hanging", "dead",
]

# Total observation dimensionality: 16 + 16 + 4 + 2.
OBS_DIM = 2 * len(CHAR_FEATURES) + 6


def norm(v: float, scale: float) -> float:
    """Clamp ``v / scale`` into [-1, 1]."""
    return max(-1.0, min(1.0, float(v) / scale))


def obs_feature_names() -> list[str]:
    """Human-readable name for each index of the 38-dim observation vector."""
    return (
        [f"me_{f}" for f in CHAR_FEATURES]
        + [f"opp_{f}" for f in CHAR_FEATURES]
        + ["rel_dx", "rel_dy", "rel_dist", "facing_align", "frame", "paused"]
    )


def chars_by_id(state: dict) -> dict[int, dict]:
    """Map player id -> character dict for a bridge state snapshot."""
    return {c["id"]: c for c in state["chars"]}


def pick_chars(state: dict, me_id: int) -> tuple[Optional[dict], Optional[dict]]:
    """Return (me, opponent) character dicts for the given player id."""
    chars = chars_by_id(state)
    me = chars.get(me_id)
    opp_id = next((cid for cid in chars if cid != me_id), None)
    return me, chars.get(opp_id)


def char_vec(c: dict) -> list[float]:
    """Normalized 16-dim feature vector for one character snapshot."""
    return [
        norm(c["x"], _POS), norm(c["y"], _POS),
        norm(c["nxs"], _VEL), norm(c["nys"], _VEL),
        1.0 if c["facing"] else -1.0,
        norm(c["damage"], _DMG),
        norm(c["stocks"], 5.0),
        1.0 if c["ground"] else -1.0,
        norm(c["jumpCount"], 3.0),
        norm(c["shieldPower"], 100.0),
        1.0 if c["shielding"] else -1.0,
        1.0 if c["hitstun"] else -1.0,
        1.0 if c["atkFrame"] else -1.0,
        norm(c["atkExec"], 60.0),
        1.0 if c["hanging"] else -1.0,
        1.0 if c["dead"] else -1.0,
    ]


def build_obs(state: dict, me_id: int) -> np.ndarray:
    """Build the 38-dim float32 observation for player ``me_id``.

    Returns an all-zero vector if either character is missing from the
    snapshot (e.g. during match teardown).
    """
    me, opp = pick_chars(state, me_id)
    if me is None or opp is None:
        return np.zeros((OBS_DIM,), dtype=np.float32)
    dx = opp["x"] - me["x"]
    dy = opp["y"] - me["y"]
    dist = math.sqrt(dx * dx + dy * dy)
    vec = (
        char_vec(me)
        + char_vec(opp)
        + [
            norm(dx, _POS), norm(dy, _POS), norm(dist, _POS),
            1.0 if (dx >= 0) == bool(me["facing"]) else -1.0,
        ]
        + [norm(state["frame"], 1e5), 1.0 if state["paused"] else -1.0]
    )
    return np.asarray(vec, dtype=np.float32)


def reward_delta(prev: dict, cur: dict, me_id: int, ko_bonus: float = 10.0) -> float:
    """Damage-delta shaping + KO bonuses between two consecutive snapshots.

    Shared by ``SSF2Env._reward`` and the bot runner's trajectory recorder.
    """
    pme, popp = pick_chars(prev, me_id)
    me, opp = pick_chars(cur, me_id)
    if pme is None or popp is None or me is None or opp is None:
        return 0.0
    r = 0.0
    # Damage dealt is good; damage taken is bad.
    r += (opp["damage"] - popp["damage"]) / 10.0
    r -= (me["damage"] - pme["damage"]) / 10.0
    # Stock changes (KOs).
    r += (popp["stocks"] - opp["stocks"]) * ko_bonus
    r -= (pme["stocks"] - me["stocks"]) * ko_bonus
    return r
