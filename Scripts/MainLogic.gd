extends Control
class_name MainLogic

#State
var current_state : Global.State
var previous_state : Global.State
var current_color_profile : ColorProfile
var current_audio_profile : AudioProfile

#Controllers
@export var ui_controller : UIController
@export var hourglass : HourglassController

#References
@export var timer : Timer
@export var settings_panel : Panel
@export var audio_stream_player : AudioStreamPlayer


#Set defaults
func _ready() -> void:
	current_state = Global.State.FOCUS
	_on_theme_select(1) # set default profiles
	_on_audio_selected(0)
	get_window().always_on_top = true
	timer.wait_time = 1800


#Update time label every frame
func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60
	var number_display = str(minutes) + ":" + str(seconds)
	if(seconds < 10):
		number_display = str(minutes) + ":0" + str(seconds)
	if(!timer.is_stopped()):
		ui_controller.update_timer_progress(timer.wait_time - timer.time_left, number_display)


#Switch to a different state, focus, break or user-selected-pause
#from_pause is to make sure we dont play the new state sound whenever the player unpauses
func switch_state(new_state : Global.State, from_pause : bool) -> void:
	if(current_state == new_state && timer.is_stopped() == false):
		return
	previous_state = current_state
	
	match new_state:
		Global.State.FOCUS:
			if(!from_pause):
				timer.start(Global.focus_duration)
				play_audio(current_audio_profile.focus_transition_audio)
			ui_controller.update_ui_state(Global.focus_duration, current_color_profile.focus_color, "Focus")
			hourglass.start()
			
		Global.State.BREAK:
			if(!from_pause):
				timer.start(Global.short_pause_duration)
				play_audio(current_audio_profile.break_transition_audio)
			ui_controller.update_ui_state(Global.short_pause_duration, current_color_profile.break_color, "Relax")
			hourglass.start()
			
		Global.State.PAUSED:
			ui_controller.update_ui_state(0, current_color_profile.pause_color, "Paused")
			hourglass.stop()
			
	current_state = new_state


func resume():
	timer.paused = false


func play_audio(stream):
	audio_stream_player.stream = stream
	audio_stream_player.play()


#region Buttons
#After the timer runs out, switch state
func _on_timer_timeout() -> void:
	if(current_state == Global.State.FOCUS):
		switch_state(Global.State.BREAK, false)
	elif(current_state == Global.State.BREAK):
		switch_state(Global.State.FOCUS, false)


func _on_settings_button_pressed() -> void:
	# next state is opposite of current state
	var next_state = !ui_controller.is_settings_open() 
	ui_controller.tween_settings_panel(next_state)
	timer.paused = next_state #Start or pause timer depending on settings panel open or closed
	if(next_state == true):
		switch_state(Global.State.PAUSED, false)
	if(next_state == false):
		switch_state(previous_state, true)	


func _on_pause() -> void:
	timer.paused = !timer.paused
	play_audio(current_audio_profile.pause_audio)
	
	if(timer.paused == false):
		switch_state(previous_state, true)
	else:
		switch_state(Global.State.PAUSED, false)


func _next_state_pressed() -> void:
	if(timer.is_stopped()): #First time running, start focus state
		switch_state(Global.State.FOCUS, false)
		return
	resume()
	if(current_state == Global.State.FOCUS):
		switch_state(Global.State.BREAK, false)
	elif(current_state == Global.State.BREAK):
		switch_state(Global.State.FOCUS, false)
	elif(current_state == Global.State.PAUSED):
		switch_state(previous_state, true)


func _on_audio_selected(index: int) -> void:
	match index:
		0: 	
			current_audio_profile = Global.soft_audio_profile
		1:
			current_audio_profile = Global.harsh_audio_profile
		2:
			current_audio_profile = Global.alarm_audio_profile


func _on_theme_select(index: int) -> void:
	match index:
		0:
			current_color_profile = Global.green_theme
		1:
			current_color_profile = Global.dark_theme
		2:
			current_color_profile = Global.color_blind_dark_theme
		3: 
			current_color_profile = Global.pomodoro_red_theme
			
	ui_controller.update_background_colors(current_color_profile.background_color)

#endregion
