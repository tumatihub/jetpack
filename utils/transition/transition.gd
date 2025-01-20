class_name Transition
extends CanvasLayer

signal end_transition

@export var _pos_out: Vector2
@export var _pos_in: Vector2
@export var _texture_pivot: Control
@export var _transition_time: float
@export var _transit_out_at_start: bool

func _ready() -> void:
	if _transit_out_at_start:
		transit_out()

func transit_out() -> void:
	var tween := create_tween()
	tween.tween_property(_texture_pivot, "global_position", _pos_out, _transition_time)
	tween.tween_callback(end_transition.emit)

func transit_in() -> void:
	var tween := create_tween()
	tween.tween_property(_texture_pivot, "global_position", _pos_in, _transition_time)
	tween.tween_callback(end_transition.emit)
