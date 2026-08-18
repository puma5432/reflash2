"""ControlsObject bit layout, verified against
com.mcleodgaming.ssf2.util.ControlsObject in the decompiled engine.

A controls mask is one frame of *held* input; the engine derives press/release
edges from consecutive masks itself.
"""

from __future__ import annotations

#: No input held (mask 0). Named so scripts read uniformly: ``(NOOP, 30)``.
NOOP = 0

# Bit constants (must match ControlsObject.as exactly)
START = 1 << 3
TAUNT = 1 << 2

LEFT = 1 << 9
RIGHT = 1 << 8
UP = 1 << 11
DOWN = 1 << 10
DT_DASH = 1 << 12
AUTO_DASH = 1 << 13
DASH = 1 << 14

ATTACK = 1 << 5   # attack
SPECIAL = 1 << 6   # special
GRAB = 1 << 4
SHIELD = 1 << 1
SHIELD2 = 1 << 20

TAP_JUMP = 1 << 0
JUMP = 1 << 7
JUMP2 = 1 << 19
JUMP3 = 1 << 21

C_LEFT = 1 << 16
C_RIGHT = 1 << 15
C_UP = 1 << 18
C_DOWN = 1 << 17

ALL_BITS = (1 << 22) - 1


BITS = {
    "TAP_JUMP": TAP_JUMP,
    "SHIELD": SHIELD,
    "TAUNT": TAUNT,
    "START": START,
    "GRAB": GRAB,
    "SPECIAL": SPECIAL,
    "ATTACK": ATTACK,
    "JUMP": JUMP,
    "RIGHT": RIGHT,
    "LEFT": LEFT,
    "DOWN": DOWN,
    "UP": UP,
    "DT_DASH": DT_DASH,
    "AUTO_DASH": AUTO_DASH,
    "DASH": DASH,
    "C_RIGHT": C_RIGHT,
    "C_LEFT": C_LEFT,
    "C_DOWN": C_DOWN,
    "C_UP": C_UP,
    "JUMP2": JUMP2,
    "SHIELD2": SHIELD2,
    "JUMP3": JUMP3,
}

_bit_names = {v: k for k, v in BITS.items()}


def bit_name_map() -> dict[int, str]:
    return dict(_bit_names)


def describe_mask(mask: int) -> str:
    """Human-readable list of the bits set in a controls mask."""
    if mask == 0:
        return "(none)"
    return "|".join(_bit_names[b] for b in sorted(_bit_names) if mask & b)


class Controls:
    """Small builder for composing a one-frame controls mask."""

    def __init__(self, mask: int = 0) -> None:
        if not isinstance(mask, int) or mask < 0 or mask & ~ALL_BITS:
            raise ValueError(f"invalid controls mask: {mask!r}")
        self.mask = mask

    def set(self, name: str, value: bool = True) -> "Controls":
        bit = BITS.get(name.upper())
        if bit is None:
            raise KeyError(f"unknown control: {name!r}")
        self.mask = (self.mask | bit) if value else (self.mask & ~bit)
        return self

    def clear(self) -> "Controls":
        self.mask = 0
        return self

    def __int__(self) -> int:
        return self.mask

    def __repr__(self) -> str:
        return f"Controls({describe_mask(self.mask)})"
