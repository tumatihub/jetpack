class_name Spawner
extends Node2D

@export var _item_delay: float = 20
@export var _item_delay_variation: float = 5
@export var _item_chance: float = 0.8
@export var _item_fail_max: int = 2

@export var _obstacles: Array[SpawnItem]
@export var _items: Array[SpawnItem]
@export var _timer: Timer

var _item_cooldown: float
var _item_fail_count: int = 0

func spawn() -> void:
	var _spawn_item_list = _obstacles
	if _item_cooldown <= 0:
		if _item_fail_count >= _item_fail_max:
			_spawn_item_list = _items
			_item_fail_count = 0
		elif randf() < _item_chance:
			_spawn_item_list = _items
		else:
			_item_fail_count += 1
		_restart_cooldown()
	var item := _spawn_item_list.pick_random() as SpawnItem
	var instance := item.scene.instantiate() as Node2D
	instance.global_position = item.possible_positions.pick_random()
	add_child(instance)
	var time: float = item.time_before_next
	if not item.use_absolute_time:
		time = item.time_before_next * GameManager.get_start_speed()/GameManager.get_speed()
	_timer.start(time)

func _restart_cooldown() -> void:
	_item_cooldown = randf_range(_item_delay - _item_delay_variation, _item_delay + _item_delay_variation)

func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)
	_restart_cooldown()
	spawn()

func _process(delta: float) -> void:
	if _item_cooldown > 0:
		_item_cooldown -= delta

func _on_timer_timeout() -> void:
	spawn()
