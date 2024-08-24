extends Control

enum State {WORK, BREAK, PAUSED}
var current_state : State
var previous_state : State
var timer_active = false
var user_selected_timer_value = 1800

@onready var status_label: Label = $ColorRect/MainLabel
@onready var color_rect: ColorRect = $ColorRect
@onready var timer_label: Label = $ColorRect/TimerLabel
@onready var timer: Timer = $Timer
@onready var button: Button = $ColorRect/WorkButton
@onready var settings_panel: Panel = $ColorRect/SettingsPanel
@onready var check_button: CheckButton = $ColorRect/SettingsPanel/CheckButton
@onready var pause_button: Button = $ColorRect/PauseButton

func _ready() -> void:
	current_state = State.PAUSED
	get_window().always_on_top = true
	settings_panel.visible = false
	timer_label.text = "30:00"
	timer.wait_time = 1800

func _process(_delta: float) -> void:
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60
	if(!timer.is_stopped()):
		timer_label.text = str(minutes) + ":" + str(seconds)

func switch_state(state : State):
	if(current_state == state):
		print("Same state")
		pass
	
	previous_state = current_state
	match state:
		State.WORK:
			color_rect.color = Color.RED
			status_label.text = "Working Hard!"
		State.BREAK:
			reset_timer()
			color_rect.color = Color.FOREST_GREEN
			status_label.text = "Take a break!"
		State.PAUSED:
			color_rect.color = Color.YELLOW
			status_label.text = "Paused!"
	current_state = state

func start_if_stopped():
	if(timer.is_stopped()): #This only happens at start, otherwise its just paused
		timer.start()
	
	if(timer.paused == true):
		timer.paused = false
		
func reset_timer():
	timer.start(user_selected_timer_value)

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

func _on_timevalue_changed(value: float) -> void:
	print("New timer set to: " + str(value))
	var new_time = 60*value
	timer.wait_time = new_time
	user_selected_timer_value = new_time
	timer_label.text = str(timer.wait_time)

func _on_pause() -> void:
	timer.paused = !timer.paused
	if(timer.paused == false):
		switch_state(previous_state)
	else:
		switch_state(State.PAUSED)
		
func _button_pressed() -> void:
	reset_timer()
	start_if_stopped()
	switch_state(State.WORK)

func _take_break_button() -> void:
	reset_timer()
	start_if_stopped()
	switch_state(State.BREAK)
