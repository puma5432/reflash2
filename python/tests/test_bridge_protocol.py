from __future__ import annotations

from ssf2_rl.bridge import SSF2Bridge, _BINARY_CHAR, _BINARY_PREFIX


def test_binary_step_complete_decodes_minimal_state() -> None:
    bridge = SSF2Bridge(state_transport="json")
    bridge._char_names = {1: "Marth"}
    flags = 1 | 2 | 4 | 8 | 16
    payload = _BINARY_PREFIX.pack(7, 3, 42, 1, 0, 1, 0) + _BINARY_CHAR.pack(
        1, 10.5, -20.25, 1.5, -2.5, 1, 37.0, 4, 1, 2, 75.0, flags, 6.0
    )

    bridge._dispatch_binary_state(2, payload)

    event = bridge._events.get_nowait()
    assert event["type"] == "step_complete"
    assert event["request"] == 7
    state = event["state"]
    assert state["frame"] == 42
    assert state["paused"] == 1
    assert state["ended"] == 0
    char = state["chars"][0]
    assert char["name"] == "Marth"
    assert char["x"] == 10.5
    assert char["shielding"] == 1
    assert char["hitstun"] == 1
    assert char["atkFrame"] == 1
    assert char["hanging"] == 1
    assert char["dead"] == 1


def test_match_ready_caches_names_metadata_and_generation() -> None:
    bridge = SSF2Bridge(state_transport="json")
    bridge._dispatch({
        "type": "match_ready",
        "request": 2,
        "generation": 9,
        "metadata": {"platforms": [{"x": 0}]},
        "state": {
            "type": "state",
            "schema": 3,
            "frame": 1,
            "paused": 0,
            "ended": 0,
            "chars": [{"id": 2, "name": "Zero Suit Samus"}],
        },
    })

    assert bridge.match_generation == 9
    assert bridge.match_metadata["platforms"] == [{"x": 0}]
    assert bridge._char_names[2] == "Zero Suit Samus"
