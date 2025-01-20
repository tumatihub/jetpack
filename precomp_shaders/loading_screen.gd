extends Control

@export var _next_scene: PackedScene

func _ready() -> void:
	get_tree().create_timer(3).timeout.connect(func():
		get_tree().change_scene_to_packed(_next_scene)
	)
