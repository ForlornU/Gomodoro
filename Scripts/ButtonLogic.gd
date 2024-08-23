extends Control

enum State {WORK, BREAK, PAUSED}
var current_state : State
var timer_active = false

@onready var status_label: Label = $ColorRect/MainLabel
@onready var color_rect: ColorRect = $ColorRect
@onready var timer_label: Label = $ColorRect/TimerLabel
@onready var timer: Timer = $Timer
@onready var button: Button = $ColorRect/StartButton
@onready var settings_panel: Panel = $ColorRect/SettingsPanel
@onready var check_button: CheckButton = $ColorRect/SettingsPanel/CheckButton

func _ready() -> void:
	current_state = State.PAUSED
	get_window().always_on_top = true
	settings_panel.visible = false
	timer_label.text = "30:00"
	timer.wait_time = 1800

func _process(delta: float) -> void:
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60
	if(!timer.is_stopped()):
		timer_label.text = str(minutes) + ":" + str(seconds)

func _button_pressed() -> void:
	if(timer.is_stopped()): #This only happens at start, otherwise its just paused
		timer.start()
		current_state = State.WORK
	switch_state()

func switch_state():
	if(current_state == State.WORK):
		color_rect.color = Color.RED
		status_label.text = "Working Hard!"
	elif(current_state == State.BREAK):
		color_rect.color = Color.FOREST_GREEN
		status_label.text = "Take a break!"
	else:
		color_rect.color = Color.YELLOW
		status_label.text = "Paused!"

func _on_timer_timeout() -> void:
	_button_pressed()

func _on_settings_button_pressed() -> void:
	settings_panel.visible = !settings_panel.visible

func _always_on_top_toggle(toggled_on: bool) -> void:
	get_window().always_on_top = toggled_on
	#ProjectSettings.set_setting("display/window/size/always_on_top", toggled_on)

func _on_timevalue_changed(value: float) -> void:
	print("value changed, float")
	timer.wait_time = 60*value
	timer_label.text = str(timer.wait_time)
