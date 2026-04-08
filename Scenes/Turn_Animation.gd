extends ColorRect
class_name Combat_animations 


@export var final_height: float = 40.0
@export var duration: float = 0.4
@onready var label: Label = $"../Label"
@onready var stack_ui_0: PotionStackUI = $"../Combat_UI/PotionRow/StackUI0"
@onready var stack_ui_1: PotionStackUI = $"../Combat_UI/PotionRow/StackUI1"
@onready var stack_ui_2: PotionStackUI = $"../Combat_UI/PotionRow/StackUI2"
@onready var potion_row: HBoxContainer = $"../Combat_UI/PotionRow"
@onready var potion_card_holder: TextureRect = $"../Combat_UI/Potion_card_holder"

var center_y = position.y
var center_x = position.x
## center is 324 for y



func play_intro():

	 
	size.y = 0
	modulate.a = 0
	position.y =  284
	position.x = center_x 


	var tween = create_tween()
	tween.set_parallel(true)   

	# Expand height
	tween.tween_property(self, "size:y", final_height, duration)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)



	# Fade in
	tween.tween_property(self, "modulate:a", 1.0, duration)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
		
func mid_bar_vanish():
	var tween  = create_tween()
	tween.tween_property(self, "size:y", 0, 1)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	# Fade in
	tween.tween_property(self, "modulate:a", 0, 1)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
func Slide_in_out_player_turn():
	var tween = create_tween()

	tween.tween_property(label, "position:x", 520 , duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	tween.tween_property(label, "position:x", 540 , duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	

	


func slide_out_player_turn():
	var tween = create_tween()
	
	tween.tween_property(label, "position:x", -1500, 1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
func Potion_card_popup():
	
	stack_ui_0.position.y += 200
	stack_ui_1.position.y += 200
	stack_ui_2.position.y += 200
	

	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(stack_ui_0, "position:y", -20, .4)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	
	tween.tween_property(stack_ui_1, "position:y", -20, .6)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	

	
	tween.tween_property(stack_ui_2, "position:y", -20, .8)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.set_parallel(false)
	
	tween.tween_property(stack_ui_0, "position:y", 0, .1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	tween.tween_property(stack_ui_1, "position:y", 0, .1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	tween.tween_property(stack_ui_2, "position:y", 0, .1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	
	
func card_holder_popup():
	var tween = create_tween()
	
	tween.tween_property(potion_card_holder, "position:y", 375, .8)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	pass
