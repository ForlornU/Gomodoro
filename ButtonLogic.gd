extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var timer_label: Label = $ColorRect/TimerLabel
var timer : float = 0.0
var timer_status = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_label.text = "00:00"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	timer_label.text = str(timer)

func _button_pressed() -> void:

	timer_status = !timer_status
	
	if(timer_status == true):
		color_rect.color = Color.RED
	else:
		color_rect.color = Color.FOREST_GREEN
