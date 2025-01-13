class_name MissileLauncher
extends Node2D

@export var _missile_scene: PackedScene

func _ready() -> void:
	_create_missile()

func _create_missile() -> void:
	var missile := _missile_scene.instantiate() as Missile
	missile.global_position = global_position
	add_sibling(missile)
	queue_free()
