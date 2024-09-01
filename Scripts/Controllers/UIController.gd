extends Node
class_name UIController

@onready var color_rect: ColorRect = $"../ColorRect"
@onready var main_label: Label = $"../ColorRect/MainLabel"
@onready var timer_label: Label = $"../ColorRect/TimerLabel"
@onready var settings_panel: Panel = $"../ColorRect/SettingsPanel"
@onready var texture_progress_bar: TextureProgressBar = $"../ColorRect/TimerLabel/TextureProgressBar"
@onready var color_fade: Sprite2D = $"../ColorRect/ColorFade"

func _ready() -> void:
	settings_panel.visible = false
	timer_label.text = "--:--"
	settings_panel.position = Vector2(63,-450)
	texture_progress_bar.value = texture_progress_bar.max_value

func update_timer_progress(progress_value : int, timer_text : String) -> void:
	texture_progress_bar.value = progress_value
	timer_label.text = timer_text
	
func update_ui_state(new_max_value : int, new_state_color : Color, label_text : String) -> void:
	texture_progress_bar.max_value = new_max_value
	main_label.text = label_text
	tween_bg_color(new_state_color)

func tween_bg_color(color : Color):
	var color_tween = create_tween()
	color_tween.set_trans(Tween.TRANS_QUAD)
	color_tween.set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(color_fade, "self_modulate", color, 0.5)
	await color_tween.finished
	
func is_settings_open() -> bool:
	return settings_panel.visible
	
func tween_settings_panel(active : bool):
	var slide_tween = create_tween()
	slide_tween.set_trans(Tween.TRANS_BACK)
	slide_tween.set_ease(Tween.EASE_IN_OUT)
	if(active):
		settings_panel.visible = true
		slide_tween.tween_property(settings_panel, "position", Vector2(62.5, 93), 0.8)
	else:
		slide_tween.tween_property(settings_panel, "position", Vector2(63,-450), 0.8)
		await slide_tween.finished
		settings_panel.visible = false
	
func update_background_colors(bg_color : Color) -> void:
	#Set main bg color
	color_rect.color = bg_color
	#Change panel stylebox theme colors
	var panel_theme = settings_panel.theme
	var stylebox : StyleBoxFlat = panel_theme.get_stylebox("panel", "Panel") as StyleBoxFlat
	var slightly_darker_color = bg_color
	var darken_scalar = 0.75
	slightly_darker_color = Color(slightly_darker_color.r * darken_scalar, slightly_darker_color.g * darken_scalar, slightly_darker_color.b * darken_scalar, slightly_darker_color.a)
	stylebox.bg_color = slightly_darker_color
	panel_theme.set_stylebox("panel", "Panel", stylebox)
