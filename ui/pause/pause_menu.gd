extends CanvasLayer

@export var _pause_menu: MarginContainer
@export var _transition_time: float = .5
@export var _sfx_button: TextureButton
@export var _music_button: TextureButton
@export var _sfx_on_texture: Texture2D
@export var _sfx_off_texture: Texture2D
@export var _music_on_texture: Texture2D
@export var _music_off_texture: Texture2D

var _start_pos_x = 400
var _end_pos_x = 0

func toggle_pause() -> void:
	if get_tree().paused:
		unpause()
	else:
		pause()

func pause() -> void:
	get_tree().paused = true
	_move_in()

func unpause() -> void:
	_move_out()

func _move_in() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(_pause_menu, "global_position:x", _end_pos_x, _transition_time)

func _move_out() -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(_pause_menu, "global_position:x", _start_pos_x, _transition_time)
	tween.tween_callback(func(): get_tree().paused = false)

func _on_pause_button_pressed() -> void:
	toggle_pause()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func _on_sfx_button_pressed() -> void:
	AudioManager.toggle_sfx()
	_update_sfx_texture()

func _on_music_button_pressed() -> void:
	AudioManager.toggle_music()
	_update_music_texture()

func _update_sfx_texture() -> void:
	if AudioManager.is_sfx_muted():
		_sfx_button.texture_normal = _sfx_off_texture
	else:
		_sfx_button.texture_normal = _sfx_on_texture

func _update_music_texture() -> void:
	if AudioManager.is_music_muted():
		_music_button.texture_normal = _music_off_texture
	else:
		_music_button.texture_normal = _music_on_texture

func _on_exit_button_pressed() -> void:
	get_tree().quit()
