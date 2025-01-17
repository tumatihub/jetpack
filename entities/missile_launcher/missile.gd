class_name Missile
extends Node2D

const WARNING_TIME: float = .5

@export var _delay: float = 2
@export var _speed: float = 2000
@export var _ui_speed: float = 300
@export var _exclamation: HBoxContainer
@export var _warning: Control
@export var _animation_player: AnimationPlayer
@export var _audio_player: AudioStreamPlayer
@export var _warning_audio_player: AudioStreamPlayer

var _player: Player
var _is_shooting: bool = false
var _locked: bool = false

func _ready() -> void:
	_player = GameManager.get_player()
	_update_positions()
	get_tree().create_timer(_delay).timeout.connect(_show_warning)

func _physics_process(delta: float) -> void:
	if _is_shooting:
		global_position.x -= _speed * delta
	else:
		_update_positions(delta)

func _update_positions(delta: float = 1) -> void:
	if _locked:
		return
	_exclamation.global_position.y = move_toward(_exclamation.global_position.y, _player.global_position.y, delta * _ui_speed)

func _show_warning() -> void:
	_warning_audio_player.play()
	_exclamation.visible = false
	_warning.global_position.y = _exclamation.global_position.y
	_warning.visible = true
	_animation_player.play(&"warning")
	_locked = true
	get_tree().create_timer(WARNING_TIME).timeout.connect(_shoot)

func _shoot() -> void:
	_is_shooting = true
	global_position.y = _exclamation.global_position.y
	_warning.visible = false
	_audio_player.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var tween := create_tween()
	tween.tween_property(_audio_player, "volume_db", -30, 1)
	tween.tween_callback(queue_free)
