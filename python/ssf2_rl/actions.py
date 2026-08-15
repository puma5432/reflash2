"""Named discrete action space: control masks built from ``Controls`` bits.

Kept separate from ``env.py`` so the bot layer can use the action vocabulary
without importing Gymnasium.
"""

from __future__ import annotations

from .controls import (
    ATTACK,
    C_RIGHT,
    Controls,
    DOWN,
    GRAB,
    JUMP,
    LEFT,
    RIGHT,
    SHIELD,
    SPECIAL,
    UP,
)


def _mask(**kw: bool) -> int:
    c = Controls()
    for name, on in kw.items():
        c.set(name, on)
    return int(c)


ACTION_TABLE: list[tuple[str, int]] = [
    ("noop", 0),

    ("left", _mask(LEFT=True)),
    ("right", _mask(RIGHT=True)),
    ("up", _mask(UP=True)),
    ("down", _mask(DOWN=True)),

    ("jump", _mask(JUMP=True)),
    ("attack", _mask(ATTACK=True)),
    ("special", _mask(SPECIAL=True)),
    ("shield", _mask(SHIELD=True)),
    ("grab", _mask(GRAB=True)),
    ("left_jump", _mask(LEFT=True, JUMP=True)),
    ("right_jump", _mask(RIGHT=True, JUMP=True)),
    ("left_attack", _mask(LEFT=True, ATTACK=True)),
    ("right_attack", _mask(RIGHT=True, ATTACK=True)),
    ("left_special", _mask(LEFT=True, SPECIAL=True)),
    ("right_special", _mask(RIGHT=True, SPECIAL=True)),
    ("down_special", _mask(DOWN=True, SPECIAL=True)),
    ("jump_attack", _mask(JUMP=True, ATTACK=True)),
    ("jump_special", _mask(JUMP=True, SPECIAL=True)),
    ("down_attack", _mask(DOWN=True, ATTACK=True)),
    ("up_attack", _mask(UP=True, ATTACK=True)),
    ("cstick_right", _mask(C_RIGHT=True)),
]

ACTION_NAMES: list[str] = [name for name, _ in ACTION_TABLE]
ACTION_MASKS: list[int] = [mask for _, mask in ACTION_TABLE]


def action_index(name: str) -> int:
    """Index of a named action in ``ACTION_TABLE`` (raises if unknown)."""
    try:
        return ACTION_NAMES.index(name)
    except ValueError:
        raise ValueError(f"unknown action {name!r}; valid: {ACTION_NAMES}") from None
