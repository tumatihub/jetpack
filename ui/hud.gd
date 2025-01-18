class_name HUD
extends CanvasLayer

@export var _score_label: Label
@export var _record_label: Label
@export var _start_info_label: Label

func _ready() -> void:
	_update_score_label(GameManager.get_current_score())
	_update_record_label(GameManager.get_current_record())
	GameManager.scored.connect(_on_scored)
	GameManager.record_updated.connect(_on_record_updated)
	GameManager.player_finished_entering.connect(_on_player_finished_entering)
	GameManager.game_started.connect(_on_game_started)

func _on_scored(score: int) -> void:
	_update_score_label(score)

func _on_record_updated(record: int) -> void:
	_update_record_label(record)

func _update_score_label(score: int) -> void:
	_score_label.text = "coins: %s" % score

func _update_record_label(record: int) -> void:
	_record_label.text = "record: %s" % record

func _on_player_finished_entering() -> void:
	_start_info_label.visible = true
	_update_score_label(0)

func _on_game_started() -> void:
	_start_info_label.visible = false
