class_name Player
extends Node2D

@export var _gravity := 980
@export var _thrust_force: float = 2000
@export var _bounce_force: float = 500

var _velocity: float
var _can_move: bool = true
var _is_dead: bool = false
var _is_bouncing: bool = false
var _bounce_time: float = 0.2
var _bounce_cooldown: float = 0

func _ready() -> void:
	GameManager.set_player(self)

func _process(delta: float) -> void:
	if _bounce_cooldown > 0:
		_bounce_cooldown -= delta
	else:
		_is_bouncing = false

func _physics_process(delta: float) -> void:
	if not _is_dead and not _is_bouncing and Input.is_action_pressed("thrust"):
		_velocity -= _thrust_force * delta
	
	_velocity += _gravity * delta
	
	global_position.y += _velocity * delta

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _die() -> void:
	_is_dead = true
	_velocity = 0
	get_tree().create_timer(3).timeout.connect(_on_death_timeout)

func _bounce() -> void:
	_is_bouncing = true
	_bounce_cooldown = _bounce_time
	_velocity = 0
	var height: float = get_viewport_rect().size.y
	if global_position.y > height/2:
		_velocity -= _bounce_force
	else:
		_velocity += _bounce_force * 0.3

func _on_death_timeout() -> void:
	GameManager.reset()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _is_dead:
		return
	_bounce()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if _is_dead:
		return
	if area.owner.is_in_group("Obstacle"):
		_die()
	elif area.owner is Coin:
		var coin: Coin = area.owner as Coin
		GameManager.score(coin.get_score())
