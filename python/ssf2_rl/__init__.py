"""SSF2 RL research bridge client.

Talks to the instrumented ReFlash2 research build over a loopback TCP socket
(newline-delimited JSON). The game streams one state snapshot per simulation
frame (30 FPS) and accepts one-frame input masks for CPU-controlled characters.
"""

from .bridge import SSF2Bridge, BridgeError
from .controls import Controls, BITS, bit_name_map, describe_mask

__all__ = [
    "SSF2Bridge",
    "BridgeError",
    "Controls",
    "BITS",
    "bit_name_map",
    "describe_mask",
]
