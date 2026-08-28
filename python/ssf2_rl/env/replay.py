"""Native replay playback orchestration."""
from __future__ import annotations
import time
from typing import Literal
from ..data.episode import Episode
from ..data.ssfrec import load_ssfrec
from ..protocol.bridge import BridgeError


def replay_ssfrec(env,
                  path: str,
                  collect: bool = True,
                  timeout: float = 30.0,
                  speed: Literal["realtime", "fast"] = "realtime",
                  batch_frames: int = 256) -> Episode:
    if speed not in {"realtime", "fast"}:
        raise ValueError("speed must be 'realtime' or 'fast'")
    if not isinstance(batch_frames, int) or isinstance(batch_frames, bool) or not 0 < batch_frames <= 4096:
        raise ValueError("batch_frames must be an integer from 1 through 4096")
    if speed == "fast" and not collect:
        raise ValueError("speed='fast' requires collect=True")
    replay_json = load_ssfrec(path);
    bridge = env._connect()
    if speed == "fast":
        return _replay_ssfrec_fast(env, bridge, replay_json, timeout, batch_frames)
    if collect:
        bridge.wait_reply(bridge.start_recording(), "ack", timeout=5.0)
    reply = bridge.wait_reply(bridge.load_replay(replay_json), "ack", timeout=timeout); frame_count = reply.get("frames", 0)
    if not collect:
        return Episode(frames=[], config=replay_json.get("matchSettings", {}))
    deadline = time.monotonic() + max(30.0, frame_count / 30.0 * 2 + 10.0)
    while True:
        state = bridge.latest_state()
        if state is not None and (state.get("frame", 0) >= frame_count or state.get("ended")):
            break
        if time.monotonic() > deadline:
            raise BridgeError(f"timed out waiting for replay to finish (frame {state and state.get('frame')}/{frame_count})")
        time.sleep(.25)
    bridge.wait_reply(bridge.stop_recording(), "ack", timeout=5.0)
    bridge.get_episode()
    event = bridge.wait_episode(timeout=30.0)
    return Episode(event["frames"], replay_json.get("matchSettings", {}), event.get("generation", 0))


def _replay_ssfrec_fast(env, bridge, replay_json: dict, timeout: float, batch_frames: int) -> Episode:
    """Collect a replay through bounded game-side synchronous batches."""
    recording = False
    paused = False
    try:
        bridge.wait_reply(bridge.start_recording(), "ack", timeout=5.0)
        recording = True
        # Ignore an old match's queued states before waiting for the replay to start.
        bridge.clear_pending_messages()
        load_reply = bridge.wait_reply(bridge.load_replay(replay_json, pause_on_start=True), "ack", timeout=timeout)
        frame_count = int(load_reply.get("frames", 0))
        bridge.wait_state(timeout=timeout)
        bridge.wait_reply(bridge.pause(), "ack", timeout=5.0)
        paused = True

        while True:
            reply = bridge.wait_reply(
                bridge.fast_replay_batch(batch_frames), "fast_replay_complete", timeout=timeout
            )
            advanced = int(reply.get("advanced", 0))
            done = bool(reply.get("done")) or int(reply.get("frame", 0)) >= frame_count
            if done:
                final_state = reply.get("state")
                if isinstance(final_state, dict):
                    env._last_state = final_state
                break
            if advanced <= 0:
                raise BridgeError("fast replay batch completed without advancing")

        bridge.wait_reply(bridge.stop_recording(), "ack", timeout=5.0)
        recording = False
        bridge.get_episode()
        event = bridge.wait_episode(timeout=timeout)
        return Episode(event["frames"], replay_json.get("matchSettings", {}), event.get("generation", 0))
    finally:
        if recording:
            try:
                bridge.wait_reply(bridge.stop_recording(), "ack", timeout=5.0)
            except BridgeError:
                pass
        if paused:
            try:
                bridge.wait_reply(bridge.resume(), "ack", timeout=5.0)
            except BridgeError:
                pass
