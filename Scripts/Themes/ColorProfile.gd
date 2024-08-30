extends Node
class_name ColorProfile

var background_color : Color
var focus_color : Color
var break_color : Color
var pause_color : Color

func _init(p_background_color : Color, p_focus_color : Color, p_break_color : Color, p_pause_color : Color):
	self.background_color = p_background_color
	self.focus_color = p_focus_color
	self.break_color = p_break_color
	self.pause_color = p_pause_color 
