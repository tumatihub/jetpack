extends Node2D

@export var _shoot_groups: Array[ShootGroup]
@export var _flash_scene: PackedScene
@export var _flash_sfx: AudioStream
@export var _charge_player: AudioStreamPlayer

var _laser_traps: Array[LaserTrapLine]
var _available_traps: ShootGroup = ShootGroup.new()
var _is_flashing: bool = false


func _ready() -> void:
	_available_traps = _get_available_traps()
	for child in get_children():
		if not child.is_in_group("Obstacle"):
			continue
		_laser_traps.append(child)
		var laser := child as LaserTrapLine
		laser.flash.connect(_on_laser_flash)
	for idx in _available_traps.traps:
		_laser_traps[idx].enter()
	get_tree().create_timer(1.1).timeout.connect(_on_finished_entering)

func _get_available_traps() -> ShootGroup:
	var group := ShootGroup.new()
	for shoot_group in _shoot_groups:
		for idx in shoot_group.traps:
			if idx not in _available_traps.traps:
				group.traps.append(idx)
	return group

func _start_shooting() -> void:
	_shoot_groups.shuffle()
	for g in _shoot_groups:
		for idx in g.traps:
			_laser_traps[idx].shoot()
			_charge_player.play()
		await get_tree().create_timer(1.6).timeout
	_exit_cannons()

func _exit_cannons() -> void:
	for idx in _available_traps.traps:
		_laser_traps[idx].exit()

func _on_finished_entering() -> void:
	_start_shooting()

func _on_laser_flash() -> void:
	_flash()

func _flash() -> void:
	if _is_flashing:
		return
	_is_flashing = true
	var flash := _flash_scene.instantiate() as Flash
	flash.color = Color.RED
	flash.audio = _flash_sfx
	flash.finished.connect(func(): _is_flashing = false)
	add_sibling(flash)
