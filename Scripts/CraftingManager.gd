class_name CraftingManager

extends Node


@export var Recipies: Array[Recipies] = []

func find_matching_recipies(slot_1: Item, slot_2:Item):
	for recipie in Recipies:
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
	print("crafted!", recipie.result.Potiontype)
	return recipie.result
	
	
