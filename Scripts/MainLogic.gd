extends Control
class_name MainLogic

#State
var current_state : Global.State
var previous_state : Global.State
var current_max_time : int
var current_color_profile : ColorProfile
var current_audio_profile : AudioProfile

#region references
@onready var color_rect: ColorRect = $ColorRect
@onready var status_label: Label = $ColorRect/MainLabel
@onready var timer_label: Label = $ColorRect/TimerLabel
@onready var timer: Timer = $Timer
@onready var settings_panel: Panel = $ColorRect/SettingsPanel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var texture_progress_bar: TextureProgressBar = $ColorRect/TimerLabel/TextureProgressBar
@onready var color_fade: Sprite2D = $ColorRect/ColorFade
@onready var hourglass: hourglass_controller = $ColorRect/BottomPanel/Timer
#endregion

#Set defaults
func _ready() -> void:
	current_state = Global.State.WORK
	_on_theme_select(0) # set default theme
	_on_audio_selected(0)
	get_window().always_on_top = true
	settings_panel.visible = false
	timer_label.text = "--:--"
	timer.wait_time = 1800
	current_max_time = int(timer.wait_time)
	settings_panel.position = Vector2(145,-450)

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
	texture_progress_bar.value = current_max_time - timer.time_left

func switch_state(new_state : Global.State, from_pause : bool) -> void:
	if(current_state == new_state && timer.is_stopped() == false):
		return
	previous_state = current_state
	
	match new_state:
		Global.State.WORK:
			if(!from_pause):
				timer.start(Global.work_duration)
				play_audio(current_audio_profile.work_transition_audio)
			texture_progress_bar.max_value = Global.work_duration
			current_max_time = Global.work_duration
			texture_progress_bar.tint_progress = current_color_profile.focus_color
			status_label.text = "Work!"
			tween_bg_color(current_color_profile.focus_color)
			hourglass.start()
			
		Global.State.BREAK:
			if(!from_pause):
				timer.start(Global.short_pause_duration)
				play_audio(current_audio_profile.break_transition_audio)
			texture_progress_bar.max_value = Global.short_pause_duration
			current_max_time = Global.short_pause_duration
			texture_progress_bar.tint_progress = current_color_profile.break_color
			status_label.text = "Relax"
			tween_bg_color(current_color_profile.break_color)
			hourglass.start()
			
		Global.State.PAUSED:
			texture_progress_bar.tint_progress = current_color_profile.pause_color
			status_label.text = "Paused"
			tween_bg_color(current_color_profile.pause_color)
			hourglass.stop()
			
	current_state = new_state
	
func tween_bg_color(color : Color):
	var color_tween = create_tween()
	color_tween.set_trans(Tween.TRANS_QUAD)
	color_tween.set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(color_fade, "self_modulate", color, 0.5)
	await color_tween.finished

#Switching state should always start timer, if not pause
func resume():
	timer.paused = false
	
func play_audio(stream):
	audio_stream_player.stream = stream
	audio_stream_player.play()

#region Buttons
#After the timer runs out, switch state
func _on_timer_timeout() -> void:
	if(current_state == Global.State.WORK):
		switch_state(Global.State.BREAK, false)
	elif(current_state == Global.State.BREAK):
		switch_state(Global.State.WORK, false)

func _on_settings_button_pressed() -> void:
	var next_state = !settings_panel.visible # next state is opposite of current visible state
	#Create Tween
	var slide_tween = create_tween()
	slide_tween.set_trans(Tween.TRANS_BACK)
	slide_tween.set_ease(Tween.EASE_IN_OUT)
	#If opening menu, pause and tween
	if(next_state == true):
		settings_panel.visible = true
		timer.paused = true
		switch_state(Global.State.PAUSED, false)
		slide_tween.tween_property(settings_panel, "position", Vector2(62.5, 93), 0.8)
	#If closing menu, resume, tween and set visible = false
	if(next_state == false):
		resume()
		switch_state(previous_state, true)
		slide_tween.tween_property(settings_panel, "position", Vector2(63,-450), 0.8)
		await slide_tween.finished
		settings_panel.visible = false
		
func _always_on_top_toggle(toggled_on: bool) -> void:
	get_window().always_on_top = toggled_on

#Changing Work duration
func _on_timevalue_changed(value: int) -> void:
	print("New work duration set to: " + str(value) + " seconds")
	var new_time : int = 60*value
	Global.work_duration = new_time
	
#Changing break_duration
func _on_pausetime_changed(value: int) -> void:
	print("New break duration set to: " + str(value)+ " seconds")
	var new_time : int = 60*value
	Global.short_pause_duration = new_time

func _on_pause() -> void:
	timer.paused = !timer.paused
	play_audio(current_audio_profile.pause_audio)
	
	if(timer.paused == false):
		switch_state(previous_state, true)
	else:
		switch_state(Global.State.PAUSED, false)

func _on_sound_check_toggled(toggled_on: bool) -> void:
	audio_stream_player.volume_db = 0 if toggled_on else -80
	
func _next_state_pressed() -> void:
	if(timer.is_stopped()): #First time running
		switch_state(Global.State.WORK, false)
		return
	resume()
	if(current_state == Global.State.WORK):
		switch_state(Global.State.BREAK, false)
	elif(current_state == Global.State.BREAK):
		switch_state(Global.State.WORK, false)
	elif(current_state == Global.State.PAUSED):
		switch_state(previous_state, true)

func _on_close_button_pressed() -> void:
	_on_settings_button_pressed()
	
func _on_audio_selected(index: int) -> void:
	match index:
		0: 	
			current_audio_profile = Global.soft_audio_profile
		1:
			current_audio_profile = Global.harsh_audio_profile

func _on_theme_select(index: int) -> void:
	match index:
		0:
			current_color_profile = Global.green_theme
		1:
			current_color_profile = Global.dark_theme
		2:
			current_color_profile = Global.color_blind_dark_theme
	set_panel_bg_color()
	color_rect.color = current_color_profile.background_color
	
func set_panel_bg_color() -> void:
	var panel_theme = settings_panel.theme
	var stylebox : StyleBoxFlat = panel_theme.get_stylebox("panel", "Panel") as StyleBoxFlat
	var slightly_darker_color = current_color_profile.background_color
	var darken_scalar = 0.75
	slightly_darker_color = Color(slightly_darker_color.r * darken_scalar, slightly_darker_color.g * darken_scalar, slightly_darker_color.b * darken_scalar, slightly_darker_color.a)
	stylebox.bg_color = slightly_darker_color
	panel_theme.set_stylebox("panel", "Panel", stylebox)
	settings_panel.theme = panel_theme
#endregion
