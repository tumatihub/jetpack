extends CanvasLayer

@export var _animation_player: AnimationPlayer

var _waiting_input: bool = true

func _input(event: InputEvent) -> void:
	if _waiting_input and Input.is_anything_pressed():
		_waiting_input = false
		_animation_player.play_backwards(&"enter")
		GameManager.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"enter":
		_animation_player.play(&"blink")
