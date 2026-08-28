"""Named discrete training actions built from native SSF2 control masks."""

from __future__ import annotations

from ..game.controls import ATTACK, C_RIGHT, Controls, DOWN, GRAB, JUMP, LEFT, RIGHT, SHIELD, SPECIAL, UP


def _mask(**kwargs: bool) -> int:
    controls = Controls()
    for name, enabled in kwargs.items():
        controls.set(name, enabled)
    return int(controls)


ACTION_TABLE: list[tuple[str, int]] = [
    ("noop", 0), ("left", _mask(LEFT=True)), ("right", _mask(RIGHT=True)),
    ("up", _mask(UP=True)), ("down", _mask(DOWN=True)), ("jump", _mask(JUMP=True)),
    ("attack", _mask(ATTACK=True)), ("special", _mask(SPECIAL=True)),
    ("shield", _mask(SHIELD=True)), ("grab", _mask(GRAB=True)),
    ("left_jump", _mask(LEFT=True, JUMP=True)), ("right_jump", _mask(RIGHT=True, JUMP=True)),
    ("left_attack", _mask(LEFT=True, ATTACK=True)), ("right_attack", _mask(RIGHT=True, ATTACK=True)),
    ("left_special", _mask(LEFT=True, SPECIAL=True)), ("right_special", _mask(RIGHT=True, SPECIAL=True)),
    ("down_special", _mask(DOWN=True, SPECIAL=True)), ("jump_attack", _mask(JUMP=True, ATTACK=True)),
    ("jump_special", _mask(JUMP=True, SPECIAL=True)), ("down_attack", _mask(DOWN=True, ATTACK=True)),
    ("up_attack", _mask(UP=True, ATTACK=True)), ("cstick_right", _mask(C_RIGHT=True)),
]
ACTION_NAMES = [name for name, _ in ACTION_TABLE]
ACTION_MASKS = [mask for _, mask in ACTION_TABLE]


def action_index(name: str) -> int:
    try:
        return ACTION_NAMES.index(name)
    except ValueError:
        raise ValueError(f"unknown action {name!r}; valid: {ACTION_NAMES}") from None
