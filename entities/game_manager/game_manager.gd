extends Node2D

signal speed_raised(speed: float)

@export var _timer: Timer
@export var _max_speed: float = 1200.0

var _start_speed: float = 600.0
var _speed_rate: float = 50.0

@onready var _current_speed: float = _start_speed

func get_speed() -> float:
	return _current_speed

func get_start_speed() -> float:
	return _start_speed

func _speed_up() -> void:
	if _current_speed >= _max_speed:
		return
	_current_speed = minf(_max_speed, _current_speed + _speed_rate)
	speed_raised.emit(_current_speed)

func _on_timer_timeout() -> void:
	_speed_up()