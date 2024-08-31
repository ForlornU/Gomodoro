extends Node

@export var logic : MainLogic


func _on_always_ontop(toggled_on: bool) -> void:
	get_window().always_on_top = toggled_on
