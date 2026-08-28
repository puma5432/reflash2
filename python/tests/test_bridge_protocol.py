from __future__ import annotations

import json

import pytest

from ssf2_rl.protocol.binary import BINARY_CHAR, BINARY_PREFIX, decode_binary_state
from ssf2_rl.protocol.bridge import BridgeError, SSF2Bridge


def test_binary_step_complete_decodes_minimal_state() -> None:
    flags = 1 | 2 | 4 | 8 | 16
    payload = BINARY_PREFIX.pack(7, 3, 42, 1, 0, 1, 0) + BINARY_CHAR.pack(
        1, 10.5, -20.25, 1.5, -2.5, 1, 37.0, 4, 1, 2, 75.0, flags, 6.0, 0
    )

    event, generation = decode_binary_state(2, payload, {1: "Marth"})
    assert generation == 3
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


def test_fast_replay_batch_serializes_a_correlated_bounded_request() -> None:
    bridge = SSF2Bridge()
    messages: list[dict] = []
    bridge._send = lambda message: messages.append(message)  # type: ignore[method-assign]

    request = bridge.fast_replay_batch(256)

    assert request == 1
    assert json.loads(json.dumps(messages)) == [
        {"type": "fast_replay_batch", "request": request, "max_frames": 256}
    ]


def test_fast_replay_complete_waits_for_its_matching_request() -> None:
    bridge = SSF2Bridge()
    bridge._events.put({"type": "fast_replay_complete", "request": 2, "advanced": 256, "done": 0})
    bridge._events.put({"type": "fast_replay_complete", "request": 3, "advanced": 12, "done": 1})

    reply = bridge.wait_reply(3, "fast_replay_complete", timeout=0.1)

    assert reply["advanced"] == 12
    assert reply["done"] == 1
    assert bridge.drain_events() == [{"type": "fast_replay_complete", "request": 2, "advanced": 256, "done": 0}]


@pytest.mark.parametrize("max_frames", [0, -1, 4097, True, 1.5])
def test_fast_replay_batch_rejects_invalid_bounds(max_frames: object) -> None:
    bridge = SSF2Bridge()

    with pytest.raises(BridgeError, match="max_frames"):
        bridge.fast_replay_batch(max_frames)  # type: ignore[arg-type]


@pytest.mark.parametrize("speed,batch_frames", [("invalid", 256), ("fast", 0), ("fast", 4097)])
def test_replay_ssfrec_validates_before_connecting(speed: str, batch_frames: int) -> None:
    from ssf2_rl.env.replay import replay_ssfrec

    with pytest.raises(ValueError):
        replay_ssfrec(None, "not-read.ssfrec", speed=speed, batch_frames=batch_frames)


def test_fast_replay_requires_collection_before_connecting() -> None:
    from ssf2_rl.env.replay import replay_ssfrec

    with pytest.raises(ValueError, match="requires collect=True"):
        replay_ssfrec(None, "not-read.ssfrec", collect=False, speed="fast")
