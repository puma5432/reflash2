"""Deterministic frame-script bot: plays a fixed (mask, frames) list.

Each entry holds a raw controls mask (bit constants from
``ssf2_rl.controls``) for that many frames, so any combination of held
buttons / stick directions can be sequenced — e.g. ``(DOWN | SPECIAL, 20)``
for a down-special, ``(NOOP, 150)`` to wait. Scripts are for testing and
simple commands, not autonomous play; use ``PolicyBot`` for learned
behavior.
"""

from __future__ import annotations

import warnings
from typing import Literal, Sequence

from ..controls import ALL_BITS, describe_mask
from ..players import CharLike
from .base import Bot


class ScriptedBot(Bot):
    """Replays a list of ``(mask, frames)`` entries, one controls mask per frame.

    Args:
        script: sequence of ``(mask, frames)`` tuples. Masks are controls
            bit masks composed from the constants in ``ssf2_rl.controls``
            (e.g. ``LEFT``, ``DOWN | SPECIAL``, ``NOOP``); frame counts
            must be positive ints.
        on_end: what to do once the script is exhausted:
            ``"hold"`` keep the last entry's mask (default),
            ``"noop"`` send no input,
            ``"loop"`` restart the script from the beginning.

    Example::

        ScriptedBot(Character.Marth, [(NOOP, 150), (RIGHT, 200), (DOWN | SPECIAL, 20), (SHIELD, 15)])
    """

    def __init__(
        self,
        character: CharLike = None,
        script: Sequence[tuple[int, int]] = (),
        on_end: Literal["hold", "noop", "loop"] = "hold",
        name: str = "scripted",
    ) -> None:
        super().__init__(character)
        if not script:
            raise ValueError("script must contain at least one entry")
        if on_end not in ("hold", "noop", "loop"):
            raise ValueError(f"on_end must be hold/noop/loop, got {on_end!r}")
        self._entries: list[tuple[int, int]] = []
        for entry in script:
            mask, frames = entry
            if isinstance(mask, str):
                raise TypeError(
                    f"script entries take controls masks (ints), not action "
                    f"names; got {mask!r}. Use bit constants, e.g. DOWN | SPECIAL."
                )
            mask = int(mask)
            stray = mask & ~ALL_BITS
            if stray:
                warnings.warn(
                    f"script mask {mask:#x} has bits outside the 22-bit "
                    f"ControlsObject layout (ignored by the game): "
                    f"{describe_mask(stray)}"
                )
            frames = int(frames)
            if frames <= 0:
                raise ValueError(f"frame count must be positive, got {frames}")
            self._entries.append((mask, frames))
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
