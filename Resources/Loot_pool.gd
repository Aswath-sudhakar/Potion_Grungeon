extends Resource
class_name LootPool

@export var LootTable: Array [Loot_drops]= []


func roll_drops() -> Array[Item]:
	var drops: Array[Item] = []
	for entry in LootTable:
		if randf() <= entry.drop_chance:
			for i in entry.amount_dropped:
				drops.append(entry.item_dropped)
	return drops
	
	
