extends Sprite2D
class_name hourglass_controller

enum hourglass_turn {clockwise, counterclockwise}
var current_turn = hourglass_turn.clockwise #Starts clockwise
var starting_scale : Vector2
var keep_playing : bool = false

func start() -> void:
	if(keep_playing == true): #Ignore if we are already playing
		return
		
	keep_playing = true
	if(current_turn == hourglass_turn.clockwise):
		turn_counterclockwise()
	else:
		turn_clockwise()
		
func stop() -> void:
	keep_playing = false

func turn_clockwise():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", 360, 2)
	await tween.finished
	current_turn = hourglass_turn.counterclockwise
	if(keep_playing):
		turn_counterclockwise()
		
func turn_counterclockwise():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", 0, 2)
	await tween.finished
	current_turn = hourglass_turn.clockwise
	if(keep_playing):
		turn_clockwise()
