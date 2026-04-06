class_name EncounterPool
extends Resource

@export var possible_enemies: Array[PackedScene] = []

func get_random_enemy() -> PackedScene:
	if possible_enemies.is_empty():
		print("No enemies in pool!")
		return null
	return possible_enemies[randi() % possible_enemies.size()]
