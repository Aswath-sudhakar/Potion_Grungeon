class_name CraftingManager

extends Node

var recipies: Array = [] 




func find_matching_recipies(slot_1: Item, slot_2:Item) -> Recipies:
	for recipie in recipies:
		if recipie.matches(slot_1, slot_2):
			return recipie
	return null
	
func can_craft(slot_1: Item, slot_2: Item) -> bool:
	return find_matching_recipies(slot_1, slot_2) != null
	
func craft(slot_1:Item, slot_2:Item)-> PotionData:
	var recipie = find_matching_recipies(slot_1,slot_2)
	if recipie == null:
		print("recipie not found")
		return 
	print("Recipe object: ", recipie)
	print("Recipe properties: ", recipie.get_property_list())
	return recipie.Result
	
	
