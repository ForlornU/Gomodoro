extends Control

@onready var status_label: Label = $ColorRect/MainLabel
@onready var color_rect: ColorRect = $ColorRect
@onready var timer_label: Label = $ColorRect/TimerLabel
var timer_active = false
@onready var timer: Timer = $Timer
@onready var button: Button = $ColorRect/StartButton
@onready var settings_panel: Panel = $ColorRect/SettingsPanel

func _ready() -> void:
	settings_panel.visible = false
	timer_label.text = "30:00"
	timer.wait_time = 1800

func _process(delta: float) -> void:
	timer_label.text = str(snappedf(timer.time_left, 0.1))

func _button_pressed() -> void:
	if(timer.is_stopped()): #This only happens at start, otherwise its just paused
		timer.start()
	switch_state()

func switch_state():
	timer_active = !timer_active
	timer.paused = false
	
	if(timer_active == true):
		color_rect.color = Color.RED
		status_label.text = "Working Hard!"
	else:
		color_rect.color = Color.FOREST_GREEN
		status_label.text = "Take a break!"

func _on_timer_timeout() -> void:
	_button_pressed()

func _on_settings_button_pressed() -> void:
	settings_panel.visible = !settings_panel.visible
