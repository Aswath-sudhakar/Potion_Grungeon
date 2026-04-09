extends PointLight2D


func _ready() -> void:
	pulse()


func pulse():
	var tween = create_tween()
	tween.set_loops()
	
	tween.tween_property(self, "texture_scale", 25, 10)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		
	tween.tween_property(self, "texture_scale", 15, 10)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		
	
	
