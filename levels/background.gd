extends Node2D

@export var _clouds: Parallax2D
@export var _mountains: Parallax2D
@export var _hills: Parallax2D
@export var _floor: Parallax2D

@export_range(0, 1) var _clouds_speed_perc: float = 0.1
@export_range(0, 1) var _mountains_speed_perc: float = 0.16
@export_range(0, 1) var _hills_speed_perc: float = 0.66

func _ready() -> void:
	_update_speed(GameManager.get_speed())
	GameManager.speed_raised.connect(_on_speed_raised)

func _update_speed(speed: float) -> void:
	_clouds.autoscroll.x = -speed * _clouds_speed_perc
	_mountains.autoscroll.x = -speed * _mountains_speed_perc
	_hills.autoscroll.x = -speed * _hills_speed_perc
	_floor.autoscroll.x = -speed
	pass

func _on_speed_raised(speed: float) -> void:
	_update_speed(speed)
