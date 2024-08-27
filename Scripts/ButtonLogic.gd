extends Control

#State
enum State {WORK, BREAK, PAUSED}
var current_state : State
var previous_state : State

#Time
var work_time = 1800 #Default 30min
var short_pause_time = 300 # 5min
var cycles = 4 #How many work/break cycles before complete

#Preloaded Audio
const BACK_TO_WORK = preload("res://Assets/Audio/BackToWork.wav")
const TAKE_A_BREAK = preload("res://Assets/Audio/TakeABreak.wav")

#region references
@onready var status_label: Label = $ColorRect/MainLabel
@onready var timer_label: Label = $ColorRect/TimerLabel
@onready var timer: Timer = $Timer
@onready var settings_panel: Panel = $ColorRect/SettingsPanel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var circle: Sprite2D = $ColorRect/TimerLabel/Control/OuterCicle
@onready var texture_progress_bar: TextureProgressBar = $ColorRect/TimerLabel/TextureProgressBar
#endregion

func _ready() -> void:
	current_state = State.PAUSED
	get_window().always_on_top = true
	settings_panel.visible = false
	timer_label.text = "30:00"
	timer.wait_time = 1800

#Update time label every frame
func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60
	if(!timer.is_stopped()):
		if(minutes < 1):
			timer_label.text = str(seconds)
		else:
			timer_label.text = str(minutes) + ":" + str(seconds)
	texture_progress_bar.value = work_time - timer.time_left

func switch_state(state : State):
	if(current_state == state):
		print("ignoring same-state transition")
		return
	
	previous_state = current_state
	match state:
		State.WORK:
			circle.self_modulate = Color.DARK_RED
			texture_progress_bar.tint_progress = Color.RED
			status_label.text = "Work!"
			audio_stream_player.stream = BACK_TO_WORK
			audio_stream_player.play()
		State.BREAK:
			reset_timer()
			circle.self_modulate = Color.SEA_GREEN
			texture_progress_bar.tint_progress = Color.SEA_GREEN
			status_label.text = "Relax"
			audio_stream_player.stream = TAKE_A_BREAK
			audio_stream_player.play()
		State.PAUSED:
			circle.self_modulate = Color.YELLOW
			texture_progress_bar.tint_progress = Color.YELLOW
			status_label.text = "Paused"
	current_state = state

#Switching state should always start timer, if not pause
func resume():
	if(timer.is_stopped()): #This only happens at start, otherwise its just paused
		timer.start()
	if(timer.paused == true):
		timer.paused = false

#Start timer with new time
func reset_timer():
	timer.start(work_time)
	texture_progress_bar.max_value = work_time

#region Buttons
#After the timer runs out, switch state
func _on_timer_timeout() -> void:
	reset_timer()
	if(current_state == State.WORK):
		switch_state(State.BREAK)
	elif(current_state == State.BREAK):
		switch_state(State.WORK)

func _on_settings_button_pressed() -> void:
	settings_panel.visible = !settings_panel.visible

func _always_on_top_toggle(toggled_on: bool) -> void:
	get_window().always_on_top = toggled_on

func _on_timevalue_changed(value: int) -> void:
	print("New timer set to: " + str(value))
	var new_time : int = 60*value
	timer.wait_time = new_time
	work_time = new_time
	timer_label.text = str(timer.wait_time)

func _on_pause() -> void:
	timer.paused = !timer.paused
	if(timer.paused == false):
		switch_state(previous_state)
	else:
		switch_state(State.PAUSED)

#Start break
func _take_break_button() -> void:
	if(current_state == State.BREAK):
		return
	reset_timer()
	resume()
	switch_state(State.BREAK)

func _on_sound_check_toggled(toggled_on: bool) -> void:
	audio_stream_player.volume_db = 0 if toggled_on else -80
	
func _next_state_pressed() -> void:
	if(current_state == State.WORK):
		return
	reset_timer()
	resume()
	switch_state(State.WORK)

#endregion
