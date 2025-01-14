class_name LaserTrapLine
extends Node2D

const ENTER_ANIMATION = &"enter"
const SHOOT_ANIMATION = &"shoot"

@export var _animation_player: AnimationPlayer
@export var _shape_cast: ShapeCast2D

func enter() -> void:
	_animation_player.play(ENTER_ANIMATION)

func shoot() -> void:
	_animation_player.play(SHOOT_ANIMATION)

func exit() -> void:
	_animation_player.play_backwards(ENTER_ANIMATION)

func check_player_collision() -> void:
	if _shape_cast.is_colliding():
		GameManager.get_player().take_damage()
