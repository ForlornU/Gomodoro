extends Node

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _on_always_ontop(toggled_on: bool) -> void:
	get_window().always_on_top = toggled_on

func _on_sound_check_toggled(toggled_on: bool) -> void:
	audio_stream_player.volume_db = 0 if toggled_on else -80

#Changing Durations
func _on_worktime_changed(value: float) -> void:
	var new_time : int = 60*value
	Global.work_duration = new_time

func _on_pausetime_changed(value: float) -> void:
	var new_time : int = 60*value
	Global.short_pause_duration = new_time
