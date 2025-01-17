class_name Player
extends Node2D

signal died
signal finished_entering
signal start_input

const MIN_VELOCITY_TO_ROTATE_DOME = 300
const MAX_DOME_ROTATION_DEG = -13

@export var _gravity := 980
@export var _thrust_force: float = 2000
@export var _bounce_force: float = 500
@export var _shield_sprite: Sprite2D
@export var _fire: Sprite2D
@export var _smoke_particles: GPUParticles2D
@export var _fail_smoke_particles: GPUParticles2D
@export var _dome: Sprite2D
@export var _audio_player: AudioStreamPlayer
@export var _flash_scene: PackedScene
@export var _explosion_sfx: AudioStream
@export var _item_sfx: AudioStream
@export var _start_position: Vector2 = Vector2(400, 280)
@export var _hide_position: Vector2 = Vector2(-400, 280)

var _velocity: float
var _can_move: bool = true
var _is_dead: bool = true
var _is_bouncing: bool = false
var _bounce_time: float = 0.2
var _bounce_cooldown: float = 0
var _shield_active: bool = false
var _waiting_input: bool = false
var _entering: bool = false

func enter_map() -> void:
	_entering = true
	global_position = _hide_position
	_velocity = 0
	_smoke_particles.emitting = true
	_fire.visible = true
	var tween = create_tween()
	tween.tween_property(self, "global_position", _start_position, 2)
	tween.tween_callback(func(): 
		_waiting_input = true
		finished_entering.emit()
	)

func take_damage() -> void:
	if _shield_active:
			deactivate_shield()
	else:
		_die()

func activate_shield() -> void:
	_flash(Color.YELLOW, [], _item_sfx)
	_shield_sprite.visible = true
	_shield_active = true

func deactivate_shield() -> void:
	_flash(Color.YELLOW, [global_position], _explosion_sfx)
	_shield_sprite.visible = false
	_shield_active = false

func _ready() -> void:
	global_position = _hide_position
	GameManager.set_player(self)

func _process(delta: float) -> void:
	if _bounce_cooldown > 0:
		_bounce_cooldown -= delta
	else:
		_is_bouncing = false

func _physics_process(delta: float) -> void:
	if _entering:
		return
	if not _is_dead and not _is_bouncing and Input.is_action_pressed("thrust"):
		_velocity -= _thrust_force * delta
		_fire.visible = true
		_smoke_particles.emitting = true
		if not _audio_player.playing:
			_audio_player.play()
	else:
		_fire.visible = false
		_smoke_particles.emitting = false
		_audio_player.stop()
	
	_velocity += _gravity * delta
	
	global_position.y += _velocity * delta
	
	if _velocity > MIN_VELOCITY_TO_ROTATE_DOME:
		_dome.rotation_degrees = move_toward(_dome.rotation_degrees, MAX_DOME_ROTATION_DEG, delta * 100)
	else:
		_dome.rotation_degrees = move_toward(_dome.rotation_degrees, 0, delta * 100)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("thrust"):
		if _waiting_input:
			_entering = false
			_smoke_particles.emitting = false
			_fire.visible = false
			_is_dead = false
			_waiting_input = false
			_fail_smoke_particles.visible = true
			start_input.emit()

func _die() -> void:
	_flash(Color.RED, [global_position], _explosion_sfx)
	_fail_smoke_particles.restart()
	_is_dead = true
	_velocity = 0
	died.emit()

func _flash(color: Color = Color.WHITE, positions: Array[Vector2] = [], audio: AudioStream = null) -> void:
	var flash := _flash_scene.instantiate() as Flash
	flash.color = color
	flash.shock_wave_positions = positions
	if audio:
		flash.audio = audio
	add_sibling(flash)

func _bounce() -> void:
	_is_bouncing = true
	_bounce_cooldown = _bounce_time
	_velocity = 0
	var height: float = get_viewport_rect().size.y
	if global_position.y > height/2:
		_velocity -= _bounce_force
	else:
		_velocity += _bounce_force * 0.3

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _is_dead:
		return
	_bounce()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if _is_dead:
		return
	if area.owner.is_in_group("Obstacle"):
		if _shield_active:
			deactivate_shield()
			return
		_die()
	elif area.owner is Coin:
		var coin: Coin = area.owner as Coin
		GameManager.score(coin.get_score())
	elif area.owner.is_in_group("Item"):
		var item := area.owner as FlyingItem
		item.activate()
