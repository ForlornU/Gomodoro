extends Node
class_name ColorTheme

var background_color : Color
var focus_color : Color #= Color(0xFF7F50FF)
var break_color : Color #= Color(0x6A5ACDFF)
var pause_color : Color #= Color(0xFFD700FF)

func _init(p_background_color : Color, p_focus_color : Color, p_break_color : Color, p_pause_color : Color):
	self.background_color = p_background_color
	self.focus_color = p_focus_color
	self.break_color = p_break_color
	self.pause_color = p_pause_color 
