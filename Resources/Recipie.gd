extends Resource
class_name Recipies

@export var ingredient_1: Item
@export var ingredient_2: Item
@export var Result: PotionData
@export var Result_amount: int 


func matches(Slot_1: Item, Slot_2: Item):
	if Slot_1 == null or Slot_2 == null:
		return 
	var match_a = Slot_1 == ingredient_1 and Slot_2 == ingredient_2
	
	var match_b = Slot_1 == ingredient_2 and Slot_2 == ingredient_1
	return match_a or match_b
