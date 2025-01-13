class_name Spawner
extends Node2D

@export var _obstacles: Array[SpawnItem]
@export var _timer: Timer

func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)
	spawn()

func spawn() -> void:
	var item := _obstacles.pick_random() as SpawnItem
	var instance := item.scene.instantiate() as Node2D
	instance.global_position = item.possible_positions.pick_random()
	add_child(instance)
	_timer.start(item.time_before_next * GameManager.get_start_speed()/GameManager.get_speed())

func _on_timer_timeout() -> void:
	spawn()
