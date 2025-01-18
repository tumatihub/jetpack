extends Node2D

signal speed_raised(speed: float)
signal scored(current_score: int)
signal record_updated(record: int)
signal player_died
signal game_started
signal player_finished_entering

@export var _max_speed: float = 1200.0
@export var _speed_rate: float = 50.0
@export var _start_speed: float = 600.0

var _current_score: int
var _save_file: String = "save.sav"
var _current_record: int
var _player: Player

@onready var _current_speed: float = _start_speed

func set_player(player: Player) -> void:
	_player = player
	_player.died.connect(_on_player_died)
	_player.finished_entering.connect(_on_player_finished_entering)
	_player.start_input.connect(_on_player_start_input)

func get_player() -> Player:
	return _player

func start() -> void:
	_player.enter_map()

func _on_player_finished_entering() -> void:
	player_finished_entering.emit()

func _on_player_start_input() -> void:
	game_started.emit()

func _ready() -> void:
	var record := _load_record()
	if record == -1:
		push_error("Error while loading current record")
		record = 0
	_current_record = record

func score(score: int) -> void:
	_current_score += score
	scored.emit(_current_score)

func get_current_score() -> int:
	return _current_score

func get_current_record() -> int:
	return _current_record

func reset() -> void:
	if _current_score > _current_record:
		_save_record()
		_current_record = _current_score
		record_updated.emit(_current_record)
	_current_speed = _start_speed
	_current_score = 0
	start()

func _save_record() -> void:
	var file = FileAccess.open("user://" + _save_file, FileAccess.WRITE)
	if not file:
		printerr("Fail to open file for saving: " + str(FileAccess.get_open_error()))
		return
	file.store_32(_current_score)

func _load_record() -> int:
	if not FileAccess.file_exists("user://" + _save_file):
		return 0
	var file = FileAccess.open("user://" + _save_file, FileAccess.READ)
	if not file:
		printerr("Fail to open file for loading: " + str(FileAccess.get_open_error()))
		return -1
	var record := file.get_32()
	return record

func get_speed() -> float:
	return _current_speed

func get_start_speed() -> float:
	return _start_speed

func _speed_up() -> void:
	if _current_speed >= _max_speed:
		return
	_current_speed = minf(_max_speed, _current_speed + _speed_rate)
	speed_raised.emit(_current_speed)

func _on_timer_timeout() -> void:
	_speed_up()

func _on_player_died() -> void:
	player_died.emit()
	get_tree().create_timer(5).timeout.connect(_on_death_timeout)

func _on_death_timeout() -> void:
	reset()
