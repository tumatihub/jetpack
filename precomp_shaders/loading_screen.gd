extends Control

@export var _next_scene: PackedScene
@export var _logo: TextureRect

func _ready() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_logo, "self_modulate:a", 1, 2).from(0).set_ease(Tween.EASE_OUT)
	tween.tween_property(_logo, "self_modulate:a", 0, 1).set_ease(Tween.EASE_IN)
	tween.tween_callback(get_tree().change_scene_to_packed.bind(_next_scene))
