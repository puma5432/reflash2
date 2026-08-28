"""Binary RLB3 state and EPI0 episode decoding for the SSF2 bridge."""

from __future__ import annotations
import struct
import zlib

BINARY_MAGIC = b"RLB3"
EPISODE_MAGIC = b"EPI0"
BINARY_HEADER = struct.Struct(">4sBBHI")
EPISODE_HEADER = struct.Struct(">4siiI")
BINARY_PREFIX = struct.Struct(">iiiBBBB")
BINARY_CHAR = struct.Struct(">iffffBfhBhfHfi")
MAX_BINARY_PAYLOAD = 1024 * 1024
MAX_EPISODE_PAYLOAD = 64 * 1024 * 1024


def _character(record: tuple, names: dict[int, str]) -> dict:
    player_id, x, y, nxs, nys, facing, damage, stocks, ground, jump_count, shield_power, flags, atk_exec, controls = record
    return {"id": player_id,
            "name": names.get(player_id, f"P{player_id}"),
            "x": x, "y": y, "nxs": nxs, "nys": nys,
            "facing": facing, "damage": damage,
            "stocks": stocks, "ground": ground,
            "jumpCount": jump_count, "shieldPower": shield_power,
            "shielding": 1 if flags & 1 else 0,
            "hitstun": 1 if flags & 2 else 0,
            "atkFrame": 1 if flags & 4 else 0,
            "atkExec": atk_exec,
            "hanging": 1 if flags & 8 else 0,
            "dead": 1 if flags & 16 else 0,
            "controls": controls}


def decode_binary_state(kind: int, payload: bytes, char_names: dict[int, str]) -> tuple[dict, int]:
    if len(payload) < BINARY_PREFIX.size:
        raise ValueError("truncated binary state prefix")
    request, generation, frame, paused, ended, char_count, _ = BINARY_PREFIX.unpack_from(payload)
    expected = BINARY_PREFIX.size + char_count * BINARY_CHAR.size
    if len(payload) != expected:
        raise ValueError(f"binary state length {len(payload)} != expected {expected}")
    characters = [_character(BINARY_CHAR.unpack_from(payload, BINARY_PREFIX.size + index * BINARY_CHAR.size), char_names) for index in range(char_count)]
    state = {"type": "state", "schema": 3, "frame": frame, "paused": paused, "ended": ended, "chars": characters}
    if kind == 1:
        return state, generation
    if kind == 2:
        return {"type": "step_complete", "request": request, "state": state}, generation
    raise ValueError(f"unknown binary state kind {kind}")


def decode_episode(generation: int, frame_count: int, payload: bytes, char_names: dict[int, str]) -> dict:
    try:
        raw = zlib.decompress(payload)
    except zlib.error as exc:
        raise ValueError(f"episode decompression failed: {exc}") from exc
    frames, offset = [], 0
    for _ in range(frame_count):
        if offset + 7 > len(raw):
            raise ValueError("truncated episode frame header")
        frame, paused, ended, char_count = struct.unpack_from(">iBBB", raw, offset)
        offset += 7
        characters = []
        for _ in range(char_count):
            if offset + BINARY_CHAR.size > len(raw):
                raise ValueError("truncated episode character record")
            characters.append(_character(BINARY_CHAR.unpack_from(raw, offset), char_names))
            offset += BINARY_CHAR.size
        frames.append({"frame": frame, "paused": paused, "ended": ended, "chars": characters})
    if offset != len(raw):
        raise ValueError("unexpected trailing episode data")
    return {"type": "episode", "generation": generation, "frames": frames}
