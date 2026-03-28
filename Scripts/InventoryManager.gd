class_name Inventory_manager

extends Node

var slots: Array = []

func setup(inventory_slots: Array)-> void:
	slots = inventory_slots
	
	
func add_item(item: Item, drop_amount: int=1) ->bool:
	for slot in slots:
		if slot.item == item:
			slot.Amount += drop_amount
			print ("added onto item")
			return true 
			
	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.Amount = drop_amount
			return true
	return false
	
	pass
