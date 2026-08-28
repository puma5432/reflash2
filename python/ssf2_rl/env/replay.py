"""Native replay playback orchestration."""
from __future__ import annotations
import time
from ..data.episode import Episode
from ..data.ssfrec import load_ssfrec
from ..protocol.bridge import BridgeError


def replay_ssfrec(env, path: str, collect: bool = True, timeout: float = 30.0) -> Episode:
    replay_json = load_ssfrec(path); bridge = env._connect()
    if collect: bridge.wait_reply(bridge.start_recording(), "ack", timeout=5.0)
    reply = bridge.wait_reply(bridge.load_replay(replay_json), "ack", timeout=timeout); frame_count = reply.get("frames", 0)
    if not collect: return Episode(frames=[], config=replay_json.get("matchSettings", {}))
    deadline = time.monotonic() + max(30.0, frame_count / 30.0 * 2 + 10.0)
    while True:
        state = bridge.latest_state()
        if state is not None and (state.get("frame", 0) >= frame_count or state.get("ended")): break
        if time.monotonic() > deadline: raise BridgeError(f"timed out waiting for replay to finish (frame {state and state.get('frame')}/{frame_count})")
        time.sleep(.25)
    bridge.wait_reply(bridge.stop_recording(), "ack", timeout=5.0)
    bridge.get_episode()
    event = bridge.wait_episode(timeout=30.0)
    return Episode(event["frames"], replay_json.get("matchSettings", {}), event.get("generation", 0))
