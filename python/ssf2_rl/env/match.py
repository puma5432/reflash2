"""Match setup and lockstep reply helpers for :class:`SSF2Env`."""
from __future__ import annotations
from typing import TYPE_CHECKING
from ..game.players import Human, Player, build_match_config
from ..policy.bots.base import Bot
from ..protocol.bridge import BridgeError
if TYPE_CHECKING: from .gym_env import SSF2Env


def validate_players(players: dict[int, Player], agent_player: int) -> None:
    if agent_player not in players: raise ValueError(f"agent_player={agent_player} has no player declaration")


def reply_state(reply: dict, command: str) -> dict:
    state = reply.get("state")
    if not isinstance(state, dict): raise BridgeError(f"lockstep {command} reply did not include a state snapshot")
    return state


def reset_match(env: "SSF2Env") -> dict:
    config = env.config or build_match_config(env.players, stage=env.stage, lives=env.lives)
    bridge = env._connect(); bridge.clear_pending_messages(); request = bridge.restart_match(config)
    bridge.wait_reply(request, "ack", timeout=30.0); state = reply_state(bridge.wait_reply(request, "match_ready", timeout=30.0), "restart")
    for player_id, declaration in env.players.items():
        if isinstance(declaration, Human): continue
        bridge.takeover(player_id)
        if isinstance(declaration, Bot): bridge.send_input(player_id, 0); declaration.reset()
    bridge.set_overlay(env.render_controls)
    if env.lockstep:
        state = reply_state(bridge.wait_reply(bridge.pause(), "ack", timeout=env.step_timeout), "pause")
        if not state.get("paused"): raise BridgeError("lockstep pause acknowledgement was not paused")
        env._lockstep_paused = True
    else: env._lockstep_paused = False
    return state
