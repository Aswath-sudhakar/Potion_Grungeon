extends Node
var is_boss_fight: bool = false
var inventory: Array = []  # Array of {item: Item, amount: int}
var pending_drops: Array = []
var current_map_node: int = 0

func save_inventory(slots: Array) -> void:

	var game_save = GameSave.load_or_create()
	game_save.ingredient_slots.clear()
	
	for s in slots:
		if s.item != null and s.Amount > 0:
			inventory.append({"item": s.item, "amount": s.Amount})

func load_inventory_into_slots(slots: Array) -> void:
	var game_save = GameSave.load_or_create()
	for i in min(inventory.size(), slots.size()):
		var entry = game_save.ingredient_slots[i]
		if entry.item != null and entry.amount > 0:
			slots[i].receive_item(inventory[i]["item"], inventory[i]["amount"])
			
			
