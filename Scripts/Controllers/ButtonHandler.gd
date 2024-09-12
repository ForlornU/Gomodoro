extends Node

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _on_always_ontop(toggled_on: bool) -> void:
	get_window().always_on_top = toggled_on


#Changing Durations
func _on_worktime_changed(value: float) -> void:
	var new_time : int = round(60*value)
	Global.work_duration = new_time


func _on_pausetime_changed(value: float) -> void:
	var new_time : int = round(60*value)
	Global.short_pause_duration = new_time


func _on_volume_changed(value: float) -> void:
	audio_stream_player.volume_db = linear_to_db(value)
