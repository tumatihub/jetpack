class_name Flash
extends Node2D

signal finished

@export var _flash_texture: TextureRect
@export var _shock_wave_scene: PackedScene
@export var _audio_player: AudioStreamPlayer

var color: Color = Color.WHITE
var shock_wave_positions: Array[Vector2]
var audio: AudioStream

func _ready() -> void:
	if audio:
		_audio_player.stream = audio
		_audio_player.play()
	_flash()
	get_tree().create_timer(5).timeout.connect(queue_free)

func _flash() -> void:
	_flash_texture.self_modulate = color
	var tween := create_tween()
	tween.tween_property(_flash_texture, "self_modulate:a", 0, 0.1)
	tween.tween_callback(_spawn_all_shock_waves)
	tween.tween_callback(finished.emit)

func _spawn_all_shock_waves() -> void:
	if shock_wave_positions.size() == 0:
		return
	for pos in shock_wave_positions:
		_spawn_shock_wave(pos)

func _spawn_shock_wave(pos: Vector2) -> void:
	var shock_wave := _shock_wave_scene.instantiate() as Node2D
	shock_wave.global_position = pos
	add_sibling(shock_wave)
