extends Node
class_name AudioProfile

var work_transition_audio : AudioStream
var break_transition_audio : AudioStream
var pause_audio : AudioStream

func _init(work_sound : AudioStream, break_sound : AudioStream, pause_sound : AudioStream) -> void:
	self.work_transition_audio = work_sound
	self.break_transition_audio = break_sound
	self.pause_audio = pause_sound
