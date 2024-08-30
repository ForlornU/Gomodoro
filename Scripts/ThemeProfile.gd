extends Node
class_name ColorTheme

var background_color : Color
var focus_color : Color #= Color(0xFF7F50FF)
var break_color : Color #= Color(0x6A5ACDFF)
var pause_color : Color #= Color(0xFFD700FF)

func _init(background_color : Color, focus_color : Color, break_color : Color, pause_color : Color):
	self.background_color = background_color
	self.focus_color = focus_color
	self.break_color = break_color
	self.pause_color = pause_color 
