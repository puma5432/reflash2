"""Deterministic raw-controls frame-script bot."""

from __future__ import annotations
import warnings
from typing import Literal, Sequence
from ...game.controls import ALL_BITS, describe_mask
from ...game.players import CharLike
from .base import Bot


class ScriptedBot(Bot):
    def __init__(self, character: CharLike = None, script: Sequence[tuple[int, int]] = (), on_end: Literal["hold", "noop", "loop"] = "hold", name: str = "scripted") -> None:
        super().__init__(character)
        if not script:
            raise ValueError("script must contain at least one entry")
        if on_end not in ("hold", "noop", "loop"):
            raise ValueError(f"on_end must be hold/noop/loop, got {on_end!r}")
        self._entries = []
        for mask, frames in script:
            if isinstance(mask, str):
                raise TypeError(f"script entries take controls masks (ints), not action names; got {mask!r}. Use bit constants, e.g. DOWN | SPECIAL.")
            mask, frames = int(mask), int(frames)
            if mask & ~ALL_BITS:
                warnings.warn(f"script mask {mask:#x} has bits outside the 22-bit ControlsObject layout (ignored by the game): {describe_mask(mask & ~ALL_BITS)}")
            if frames <= 0:
                raise ValueError(f"frame count must be positive, got {frames}")
            self._entries.append((mask, frames))
        self.on_end, self.name, self._cursor, self._remaining = on_end, name, 0, 0

    def reset(self) -> None:
        self._cursor = self._remaining = 0

    @property
    def done(self) -> bool:
        return self.on_end != "loop" and self._cursor >= len(self._entries)

    def act(self, state: dict, me_id: int) -> int:
        while self._remaining <= 0:
            if self._cursor < len(self._entries):
                _, self._remaining = self._entries[self._cursor]
                self._cursor += 1
                break
            if self.on_end == "loop":
                self._cursor = 0
                continue
            return self._entries[-1][0] if self.on_end == "hold" else 0
        mask, _ = self._entries[self._cursor - 1]
        self._remaining -= 1
        return mask


def save_recording(script: Sequence[tuple[int, int]], path: str) -> None:
    import json
    from datetime import datetime, timezone
    with open(path, "w") as handle:
        json.dump({"format": "ssf2-script-v1", "recorded_at": datetime.now(timezone.utc).isoformat(), "entries": len(script), "total_frames": sum(frames for _, frames in script), "script": [[mask, frames] for mask, frames in script]}, handle, indent=2)


def load_recording(path: str) -> list[tuple[int, int]]:
    import json
    with open(path) as handle:
        data = json.load(handle)
    if data.get("format") != "ssf2-script-v1":
        raise ValueError(f"unrecognized recording format in {path}")
    return [(int(mask), int(frames)) for mask, frames in data["script"]]
