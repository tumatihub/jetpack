class_name Player
extends Node2D

const GRAVITY := 980
@export var _thrust_force: float = 2000

var _velocity: float

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("thrust"):
		_velocity -= _thrust_force * delta
	
	_velocity += GRAVITY * delta
	
	global_position.y += _velocity * delta

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
