class_name Coin
extends Node2D

@export var _animation_player: AnimationPlayer
@export var _score: int = 1

var _speed: float = 600.0

func get_score() -> int:
	return _score

func _ready() -> void:
	_speed = GameManager.get_speed()
	GameManager.speed_raised.connect(_on_speed_raised)

func _process(delta: float) -> void:
	global_position += Vector2.LEFT * delta * _get_speed()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	_animation_player.play("rotate")

func _get_speed() -> float:
	return _speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	_destroy()

func _destroy() -> void:
	queue_free()

func _on_speed_raised(current_speed: float) -> void:
	_speed = current_speed
