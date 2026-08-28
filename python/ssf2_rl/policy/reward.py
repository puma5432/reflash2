"""Reward shaping for SSF2 policy training."""

from .observation import pick_chars


def reward_delta(prev: dict, cur: dict, me_id: int, ko_bonus: float = 10.0) -> float:
    pme, popp = pick_chars(prev, me_id)
    me, opp = pick_chars(cur, me_id)
    if pme is None or popp is None or me is None or opp is None:
        return 0.0
    return ((opp["damage"] - popp["damage"]) - (me["damage"] - pme["damage"])) / 10.0 + (popp["stocks"] - opp["stocks"]) * ko_bonus - (pme["stocks"] - me["stocks"]) * ko_bonus
