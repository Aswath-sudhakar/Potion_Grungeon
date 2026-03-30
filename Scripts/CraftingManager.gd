class_name CraftingManager

extends Node

var recipies: Array = [] 
var inventory_manager: Inventory_manager
var pending_drops: Array = []
@onready var enemy_actor: EnemyActor = $EnemyActor



func find_matching_recipies(slot_1: Item, slot_2:Item) -> Recipies:
	for recipie in recipies:
		if recipie.matches(slot_1, slot_2):
			return recipie
	return null
	
func can_craft(slot_1: Item, slot_2: Item) -> bool:
	return find_matching_recipies(slot_1, slot_2) != null
	
func craft(slot_1:Item, slot_2:Item)-> Item:
	var recipie = find_matching_recipies(slot_1,slot_2)
	if recipie == null:
		print("recipie not found")
		return null
	var result = recipie.result_item
	GameState.inventory.append({"item": result, "amount": 1})
	return result
	

	
