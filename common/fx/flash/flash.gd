class_name Flash
extends Node2D

@export var _flash_texture: TextureRect
@export var _shock_wave_scene: PackedScene

var color: Color = Color.WHITE
var shock_wave_positions: Array[Vector2]

func _ready() -> void:
	_flash()

func _flash() -> void:
	_flash_texture.self_modulate = color
	var tween := create_tween()
	tween.tween_property(_flash_texture, "self_modulate:a", 0, 0.1)
	#tween.tween_callback(_spawn_all_shock_waves)
	tween.tween_callback(queue_free)

func _spawn_all_shock_waves() -> void:
	for pos in shock_wave_positions:
		_spawn_shock_wave(pos)

func _spawn_shock_wave(pos: Vector2) -> void:
	var shock_wave := _shock_wave_scene.instantiate() as Node2D
	shock_wave.global_position = pos
	add_sibling(shock_wave)
