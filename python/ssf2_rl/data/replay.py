"""Typed metadata models for decoded native SSF2 replay payloads."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from types import MappingProxyType
from typing import Any, Mapping

from .ssfrec import load_ssfrec


ControlsStream = tuple[int, ...]


def _mapping(value: object, field_name: str) -> Mapping[str, Any]:
    if not isinstance(value, Mapping):
        raise ValueError(f"{field_name} must be an object")
    return value


def _required(mapping: Mapping[str, Any], key: str, field_name: str) -> Any:
    if key not in mapping:
        raise ValueError(f"missing required field {field_name}")
    return mapping[key]


def _int(value: object, field_name: str) -> int:
    if isinstance(value, bool) or not isinstance(value, int):
        raise ValueError(f"{field_name} must be an integer")
    return value


def _number(value: object, field_name: str) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise ValueError(f"{field_name} must be a number")
    return float(value)


def _bool(value: object, field_name: str) -> bool:
    if not isinstance(value, bool):
        raise ValueError(f"{field_name} must be a boolean")
    return value


def _optional_string(value: object, field_name: str) -> str | None:
    if value is None:
        return None
    if not isinstance(value, str):
        raise ValueError(f"{field_name} must be a string or null")
    return value


def _value(mapping: Mapping[str, Any], key: str, default: Any) -> Any:
    return mapping.get(key, default)


@dataclass(frozen=True)
class ReplayPlayerSettings:
    """Recorded settings for one replay player slot."""

    x_start: float
    team: int
    start_damage: int
    y_start: float
    level: int
    exist: bool
    expansion: int
    character: str | None
    x_respawn: float
    costume: int
    is_random: bool
    name: str | None
    y_respawn: float
    human: bool
    beat_dev_online: bool
    facing_right: bool
    team_prev: int
    ranked: bool
    damage_ratio: float
    unlimited_final: bool
    socket_id: str | None
    lives: int
    attack_ratio: float
    final_smash_meter: bool

    @classmethod
    def from_dict(cls, raw: object, index: int) -> "ReplayPlayerSettings":
        data = _mapping(raw, f"playerSettings[{index}]")
        prefix = f"playerSettings[{index}]"
        return cls(
            x_start=_number(_value(data, "x_start", 0), f"{prefix}.x_start"),
            team=_int(_value(data, "team", -1), f"{prefix}.team"),
            start_damage=_int(_value(data, "startDamage", 0), f"{prefix}.startDamage"),
            y_start=_number(_value(data, "y_start", 0), f"{prefix}.y_start"),
            level=_int(_value(data, "level", 1), f"{prefix}.level"),
            exist=_bool(_value(data, "exist", True), f"{prefix}.exist"),
            expansion=_int(_value(data, "expansion", -1), f"{prefix}.expansion"),
            character=_optional_string(_value(data, "character", None), f"{prefix}.character"),
            x_respawn=_number(_value(data, "x_respawn", 0), f"{prefix}.x_respawn"),
            costume=_int(_value(data, "costume", -1), f"{prefix}.costume"),
            is_random=_bool(_value(data, "isRandom", False), f"{prefix}.isRandom"),
            name=_optional_string(_value(data, "name", None), f"{prefix}.name"),
            y_respawn=_number(_value(data, "y_respawn", 0), f"{prefix}.y_respawn"),
            human=_bool(_value(data, "human", False), f"{prefix}.human"),
            beat_dev_online=_bool(_value(data, "beatDevOnline", False), f"{prefix}.beatDevOnline"),
            facing_right=_bool(_value(data, "facingRight", True), f"{prefix}.facingRight"),
            team_prev=_int(_value(data, "team_prev", -1), f"{prefix}.team_prev"),
            ranked=_bool(_value(data, "ranked", False), f"{prefix}.ranked"),
            damage_ratio=_number(_value(data, "damageRatio", 1), f"{prefix}.damageRatio"),
            unlimited_final=_bool(_value(data, "unlimitedFinal", False), f"{prefix}.unlimitedFinal"),
            socket_id=_optional_string(_value(data, "socket_id", None), f"{prefix}.socket_id"),
            lives=_int(_value(data, "lives", 0), f"{prefix}.lives"),
            attack_ratio=_number(_value(data, "attackRatio", 1), f"{prefix}.attackRatio"),
            final_smash_meter=_bool(_value(data, "finalSmashMeter", False), f"{prefix}.finalSmashMeter"),
        )


@dataclass(frozen=True)
class ReplayItemSettings:
    """Item availability configuration recorded with a replay."""

    items: Mapping[str, bool]
    frequency: int

    @classmethod
    def from_dict(cls, raw: object) -> "ReplayItemSettings":
        data = _mapping(raw, "itemSettings")
        raw_items = _mapping(_value(data, "items", {}), "itemSettings.items")
        items = {
            str(name): _bool(enabled, f"itemSettings.items.{name}")
            for name, enabled in raw_items.items()
        }
        return cls(MappingProxyType(items), _int(_value(data, "frequency", 0), "itemSettings.frequency"))

    @property
    def enabled_items(self) -> tuple[str, ...]:
        return tuple(name for name, enabled in self.items.items() if enabled)

    @property
    def items_enabled(self) -> bool:
        return any(self.items.values())


@dataclass(frozen=True)
class ReplayMatchSettings:
    """Match rules and stage settings stored in a replay."""

    unlocks: Mapping[str, Any]
    start_damage: int
    using_time: bool
    score_limit: int
    countdown: bool
    using_lives: bool
    difficulty: int
    score_display: bool
    show_entrances: bool
    hud_display: bool
    show_countdown: bool
    lives: int
    pause_enabled: bool
    show_countdown_type: int
    time: int
    show_player_id: bool
    show_end_countdown: bool
    stage: str | None
    start_stamina: int
    custom_mode_id: str | int | None
    input_buffer: int
    teams: bool
    damage_ratio: float
    team_damage: bool
    size_ratio: float
    hazards: bool
    music_override: str | None
    using_stamina: bool
    special_modes: int
    final_smash_meter: bool
    rand_seed: int

    @classmethod
    def from_dict(cls, raw: object) -> "ReplayMatchSettings":
        data = _mapping(raw, "matchSettings")
        raw_unlocks = _mapping(_value(data, "unlocks", {}), "matchSettings.unlocks")
        custom_mode_id = _value(data, "customModeID", None)
        if custom_mode_id is not None and not isinstance(custom_mode_id, (str, int)):
            raise ValueError("matchSettings.customModeID must be a string, integer, or null")
        return cls(
            unlocks=MappingProxyType(dict(raw_unlocks)),
            start_damage=_int(_value(data, "startDamage", 0), "matchSettings.startDamage"),
            using_time=_bool(_value(data, "usingTime", False), "matchSettings.usingTime"),
            score_limit=_int(_value(data, "scoreLimit", 0), "matchSettings.scoreLimit"),
            countdown=_bool(_value(data, "countdown", True), "matchSettings.countdown"),
            using_lives=_bool(_value(data, "usingLives", True), "matchSettings.usingLives"),
            difficulty=_int(_value(data, "difficulty", 0), "matchSettings.difficulty"),
            score_display=_bool(_value(data, "scoreDisplay", False), "matchSettings.scoreDisplay"),
            show_entrances=_bool(_value(data, "showEntrances", True), "matchSettings.showEntrances"),
            hud_display=_bool(_value(data, "hudDisplay", True), "matchSettings.hudDisplay"),
            show_countdown=_bool(_value(data, "showCountdown", True), "matchSettings.showCountdown"),
            lives=_int(_value(data, "lives", 0), "matchSettings.lives"),
            pause_enabled=_bool(_value(data, "pauseEnabled", True), "matchSettings.pauseEnabled"),
            show_countdown_type=_int(_value(data, "showCountdownType", 0), "matchSettings.showCountdownType"),
            time=_int(_value(data, "time", 0), "matchSettings.time"),
            show_player_id=_bool(_value(data, "showPlayerID", False), "matchSettings.showPlayerID"),
            show_end_countdown=_bool(_value(data, "showEndCountdown", True), "matchSettings.showEndCountdown"),
            stage=_optional_string(_value(data, "stage", None), "matchSettings.stage"),
            start_stamina=_int(_value(data, "startStamina", 0), "matchSettings.startStamina"),
            custom_mode_id=custom_mode_id,
            input_buffer=_int(_value(data, "inputBuffer", 0), "matchSettings.inputBuffer"),
            teams=_bool(_value(data, "teams", False), "matchSettings.teams"),
            damage_ratio=_number(_value(data, "damageRatio", 1), "matchSettings.damageRatio"),
            team_damage=_bool(_value(data, "teamDamage", False), "matchSettings.teamDamage"),
            size_ratio=_number(_value(data, "sizeRatio", 1), "matchSettings.sizeRatio"),
            hazards=_bool(_value(data, "hazards", False), "matchSettings.hazards"),
            music_override=_optional_string(_value(data, "musicOverride", None), "matchSettings.musicOverride"),
            using_stamina=_bool(_value(data, "usingStamina", False), "matchSettings.usingStamina"),
            special_modes=_int(_value(data, "specialModes", 0), "matchSettings.specialModes"),
            final_smash_meter=_bool(_value(data, "finalSmashMeter", False), "matchSettings.finalSmashMeter"),
            rand_seed=_int(_value(data, "randSeed", 0), "matchSettings.randSeed"),
        )


@dataclass(frozen=True)
class SSFRec:
    """Immutable, typed representation of a decoded ``.ssfrec`` payload."""

    optimized: bool
    player_settings: tuple[ReplayPlayerSettings, ...]
    timestamp: str | None
    compatible_versions: tuple[str, ...]
    controls_data: tuple[ControlsStream, ...]
    rand_seed: int
    match_settings: ReplayMatchSettings
    frame_count: int
    version: str
    item_settings: ReplayItemSettings
    game_mode: int
    name: str | None

    @classmethod
    def from_dict(cls, raw: object) -> "SSFRec":
        data = _mapping(raw, "replay")
        raw_players = _required(data, "playerSettings", "playerSettings")
        raw_controls = _required(data, "controlsData", "controlsData")
        raw_versions = _value(data, "compatibleVersions", [])
        if not isinstance(raw_players, list):
            raise ValueError("playerSettings must be an array")
        if not isinstance(raw_controls, list):
            raise ValueError("controlsData must be an array")
        if not isinstance(raw_versions, list) or not all(isinstance(version, str) for version in raw_versions):
            raise ValueError("compatibleVersions must be an array of strings")

        optimized = _bool(_required(data, "optimized", "optimized"), "optimized")
        controls: list[ControlsStream] = []
        for player_index, stream in enumerate(raw_controls):
            if not isinstance(stream, list):
                raise ValueError(f"controlsData[{player_index}] must be an array")
            values = tuple(_int(value, f"controlsData[{player_index}]") for value in stream)
            if optimized and len(values) % 2:
                raise ValueError(f"controlsData[{player_index}] must contain [mask, frame_count] pairs when optimized")
            if optimized and any(frame_count < 1 for frame_count in values[1::2]):
                raise ValueError(f"controlsData[{player_index}] has a non-positive frame count")
            controls.append(values)
        if len(controls) != len(raw_players):
            raise ValueError("controlsData must have one stream per playerSettings entry")

        version = _required(data, "version", "version")
        if not isinstance(version, str):
            raise ValueError("version must be a string")
        return cls(
            optimized=optimized,
            player_settings=tuple(ReplayPlayerSettings.from_dict(player, index) for index, player in enumerate(raw_players)),
            timestamp=_optional_string(_value(data, "timestamp", None), "timestamp"),
            compatible_versions=tuple(raw_versions),
            controls_data=tuple(controls),
            rand_seed=_int(_value(data, "randSeed", 0), "randSeed"),
            match_settings=ReplayMatchSettings.from_dict(_required(data, "matchSettings", "matchSettings")),
            frame_count=_int(_required(data, "frameCount", "frameCount"), "frameCount"),
            version=version,
            item_settings=ReplayItemSettings.from_dict(_required(data, "itemSettings", "itemSettings")),
            game_mode=_int(_required(data, "gameMode", "gameMode"), "gameMode"),
            name=_optional_string(_value(data, "name", None), "name"),
        )

    @classmethod
    def from_path(cls, path: str | Path) -> "SSFRec":
        """Decode a ``.ssfrec`` file and return its typed replay metadata."""
        return cls.from_dict(load_ssfrec(path))

    @property
    def active_players(self) -> tuple[ReplayPlayerSettings, ...]:
        """Player slots that were enabled and have a selected character."""
        return tuple(player for player in self.player_settings if player.exist and player.character)

    @property
    def characters(self) -> tuple[str, ...]:
        """Character IDs for active player slots, in player-slot order."""
        return tuple(player.character for player in self.active_players if player.character is not None)

    @property
    def items_enabled(self) -> bool:
        return self.item_settings.items_enabled

    def controls_for_player(self, player_index: int) -> ControlsStream:
        """Return a zero-based player's source-format control sequence."""
        try:
            return self.controls_data[player_index]
        except IndexError as exc:
            raise IndexError(f"player index {player_index} is outside 0..{len(self.controls_data) - 1}") from exc
