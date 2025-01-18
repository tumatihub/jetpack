extends Node

const MUSIC_BUS_IDX = 1
const SFX_BUS_IDX = 2


func toggle_sfx() -> void:
	AudioServer.set_bus_mute(SFX_BUS_IDX, not AudioServer.is_bus_mute(SFX_BUS_IDX))

func toggle_music() -> void:
	AudioServer.set_bus_mute(MUSIC_BUS_IDX, not AudioServer.is_bus_mute(MUSIC_BUS_IDX))

func is_sfx_muted() -> bool:
	return AudioServer.is_bus_mute(SFX_BUS_IDX)

func is_music_muted() -> bool:
	return AudioServer.is_bus_mute(MUSIC_BUS_IDX)
