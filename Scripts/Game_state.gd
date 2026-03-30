extends Node

var inventory: Array = []  # Array of {item: Item, amount: int}
var pending_drops: Array = []

func save_inventory(slots: Array) -> void:
	inventory.clear()
	for s in slots:
		if s.item != null and s.Amount > 0:
			inventory.append({"item": s.item, "amount": s.Amount})

func load_inventory_into_slots(slots: Array) -> void:
	for i in min(inventory.size(), slots.size()):
		slots[i].receive_item(inventory[i]["item"], inventory[i]["amount"])
