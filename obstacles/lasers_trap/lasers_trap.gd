extends Node2D

var _laser_traps: Array[LaserTrapLine]
@export var _shoot_groups: Array[ShootGroup]
var _available_traps: ShootGroup = ShootGroup.new()

func _ready() -> void:
	_available_traps = _get_available_traps()
	for child in get_children():
		_laser_traps.append(child)
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
	for g in _shoot_groups:
		for idx in g.traps:
			_laser_traps[idx].shoot()
		await get_tree().create_timer(1.6).timeout
	_exit_cannons()

func _exit_cannons() -> void:
	for idx in _available_traps.traps:
		_laser_traps[idx].exit()

func _on_finished_entering() -> void:
	_start_shooting()
