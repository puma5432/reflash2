"""Decoding support for native SSF2 ``.ssfrec`` replay files."""

from __future__ import annotations

import json
import struct
import zlib
from pathlib import Path


def load_ssfrec(path: str | Path) -> dict:
    """Load an AS3 ``ByteArray.writeUTF()`` JSON replay payload.

    Files contain zlib-compressed bytes: a big-endian unsigned two-byte UTF
    length followed by exactly that many UTF-8 JSON bytes.
    """
    path = Path(path)
    try:
        decompressed = zlib.decompress(path.read_bytes())
    except (OSError, zlib.error) as exc:
        raise ValueError(f"failed to decompress {path}: {exc}") from exc
    if len(decompressed) < 2:
        raise ValueError("invalid .ssfrec file: too short")
    string_length = struct.unpack(">H", decompressed[:2])[0]
    if len(decompressed) < 2 + string_length:
        raise ValueError("invalid .ssfrec file: truncated JSON")
    try:
        return json.loads(decompressed[2 : 2 + string_length].decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ValueError(f"invalid .ssfrec JSON: {exc}") from exc
