class_name QueueOrphan
extends Node

@export var _wait_time: float = 1

var _timer: Timer = Timer.new()

@onready var _parent: Node = get_parent()

func _ready() -> void:
	_timer.wait_time = _wait_time
	_timer.timeout.connect(_on_timeout)
	add_child(_timer)
	_timer.start()

func _has_children() -> bool:
	return _parent.get_child_count() > 1

func _on_timeout() -> void:
	if not _has_children():
		_parent.queue_free()
