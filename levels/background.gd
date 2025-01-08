extends Node2D

@export var _parallax_bg: ParallaxBackground

var _current_speed: float

func _ready() -> void:
	_update_speed(GameManager.get_speed())
	GameManager.speed_raised.connect(_on_speed_raised)

func _process(delta: float) -> void:
	_parallax_bg.scroll_offset.x -= _current_speed * delta

func _update_speed(speed: float) -> void:
	_current_speed = speed

func _on_speed_raised(speed: float) -> void:
	_update_speed(speed)
