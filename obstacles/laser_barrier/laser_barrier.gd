class_name LaserBarrier
extends Node2D

@export var _speed: float = 600.0
@export var _spin: bool = false
@export var _rotation_speed: float = 90.0

func _process(delta: float) -> void:
	global_position += Vector2.LEFT * delta * _get_speed()
	if _spin:
		rotate(deg_to_rad(_rotation_speed) * delta)

func _get_speed() -> float:
	return _speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
