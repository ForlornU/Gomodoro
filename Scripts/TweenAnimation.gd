extends Sprite2D

var starting_scale : Vector2

func _ready():
	visible = true
	starting_scale = scale
	grow()

func grow():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", 360, 2)
	await tween.finished
	shrink()
		
func shrink():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", 0, 2)
	await tween.finished
	grow()
