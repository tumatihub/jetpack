class_name FlyingItem
extends Node2D

@export var _speed: float = 200
@export var _amplitude: float = 200
@export var _frequency: float = 500

@onready var _start_height := global_position.y

func activate() -> void:
	GameManager.get_player().activate_shield()
	_destroy()

func _physics_process(delta: float) -> void:
	global_position.x -= _speed * delta
	var target_y := _start_height + _amplitude * sin(Time.get_ticks_msec()/_frequency)
	global_position.y = move_toward(global_position.y, target_y, delta * _speed)

func _destroy() -> void:
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
