from __future__ import annotations

import json
import struct
import zlib
from pathlib import Path

import pytest

from ssf2_rl.data import SSFRec


def _payload() -> dict:
    return {
        "optimized": True,
        "playerSettings": [
            {
                "character": "sheik",
                "exist": True,
                "human": True,
                "name": "Player one",
                "socket_id": "session-one",
                "costume": 8,
            },
            {
                "character": "marth",
                "exist": True,
                "human": True,
                "costume": 4,
            },
        ],
        "timestamp": "Sun May 3 15:13:49 GMT-0400 2026",
        "compatibleVersions": [],
        "controlsData": [[0, 5, 32, 2], [4, 7]],
        "randSeed": 0,
        "matchSettings": {
            "stage": "smashville",
            "usingTime": True,
            "usingLives": True,
            "time": 8,
            "lives": 4,
            "inputBuffer": 3,
            "randSeed": 552015,
        },
        "frameCount": 7,
        "version": "1.4.0.1",
        "itemSettings": {"items": {"bumper": False, "pokeball": True}, "frequency": 5},
        "gameMode": 4,
        "name": "Example replay",
    }


def test_ssfrec_parses_metadata_and_preserves_compressed_controls() -> None:
    record = SSFRec.from_dict(_payload())

    assert record.version == "1.4.0.1"
    assert record.game_mode == 4
    assert record.match_settings.stage == "smashville"
    assert record.match_settings.input_buffer == 3
    assert record.characters == ("sheik", "marth")
    assert all(player.human for player in record.active_players)
    assert record.controls_for_player(0) == (0, 5, 32, 2)
    assert record.items_enabled
    assert record.item_settings.enabled_items == ("pokeball",)


def test_ssfrec_excludes_inactive_or_unselected_players() -> None:
    payload = _payload()
    payload["playerSettings"].append({"character": "samus", "exist": False})
    payload["controlsData"].append([])

    record = SSFRec.from_dict(payload)

    assert record.characters == ("sheik", "marth")
    assert len(record.active_players) == 2


@pytest.mark.parametrize("controls", [[0], [0, 0]])
def test_ssfrec_rejects_invalid_optimized_control_pairs(controls: list[int]) -> None:
    payload = _payload()
    payload["controlsData"][0] = controls

    with pytest.raises(ValueError, match=r"controlsData\[0\]"):
        SSFRec.from_dict(payload)


def test_ssfrec_from_path_uses_native_utf_zlib_decoder(tmp_path: Path) -> None:
    raw_json = json.dumps(_payload()).encode("utf-8")
    path = tmp_path / "example.ssfrec"
    path.write_bytes(zlib.compress(struct.pack(">H", len(raw_json)) + raw_json))

    record = SSFRec.from_path(path)

    assert record.name == "Example replay"
    assert record.controls_data[1] == (4, 7)
