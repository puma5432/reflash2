"""Deterministic frame-script bot: plays a fixed (action_name, frames) list.

The script vocabulary is the named action table from ``ssf2_rl.actions``
(``ACTION_NAMES`` / ``ACTION_MASKS``), so anything you can express as a
single discrete action — idle, movement, jumps, attacks, combos — can be
sequenced here. Scripts are for testing and simple commands, not autonomous
play; use ``PolicyBot`` for learned behavior.
"""

from __future__ import annotations

from typing import Literal, Sequence

from ..actions import ACTION_NAMES, ACTION_MASKS
from .base import Bot


class ScriptedBot(Bot):
    """Replays a list of ``(action_name, frames)`` entries, one mask per frame.

    Args:
        script: sequence of ``(action_name, frames)`` tuples. Names must be
            in ``ACTION_NAMES``; frame counts must be positive ints.
        on_end: what to do once the script is exhausted:
            ``"hold"`` keep the last action's mask (default),
            ``"noop"`` send no input,
            ``"loop"`` restart the script from the beginning.

    Example::

        ScriptedBot([("right", 200), ("down_special", 20), ("shield", 15)])
    """

    def __init__(
        self,
        script: Sequence[tuple[str, int]],
        on_end: Literal["hold", "noop", "loop"] = "hold",
        name: str = "scripted",
    ) -> None:
        if not script:
            raise ValueError("script must contain at least one entry")
        if on_end not in ("hold", "noop", "loop"):
            raise ValueError(f"on_end must be hold/noop/loop, got {on_end!r}")
        self._entries: list[tuple[int, int]] = []
        for entry in script:
            action_name, frames = entry
            if action_name not in ACTION_NAMES:
                raise ValueError(
                    f"unknown action {action_name!r}; valid: {ACTION_NAMES}"
                )
            frames = int(frames)
            if frames <= 0:
                raise ValueError(f"frame count must be positive, got {frames}")
            self._entries.append((ACTION_MASKS[ACTION_NAMES.index(action_name)], frames))
        self.on_end = on_end
        self.name = name
        self._cursor = 0       # index into self._entries
        self._remaining = 0    # frames left in the current entry

    def reset(self) -> None:
        """Rewind to the start of the script (called before each new match)."""
        self._cursor = 0
        self._remaining = 0

    @property
    def done(self) -> bool:
        """True once the script has been fully played (and won't loop)."""
        return (
            self.on_end != "loop"
            and self._cursor >= len(self._entries)
        )

    def act(self, state: dict, me_id: int) -> int:
        # Consume the current entry until its frame budget is spent.
        while self._remaining <= 0:
            if self._cursor < len(self._entries):
                mask, frames = self._entries[self._cursor]
                self._remaining = frames
                self._cursor += 1
                break
            # Script exhausted.
            if self.on_end == "loop": # TODO: enums instead of strings to remind player of options?
                self._cursor = 0
                continue
            if self.on_end == "hold":
                return self._entries[-1][0]
            return 0  # noop
        mask, _ = self._entries[self._cursor - 1]
        self._remaining -= 1
        return mask
