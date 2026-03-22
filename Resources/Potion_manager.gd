class_name Potion_manager
extends RefCounted

enum PotionAction {DRINK, THROW, DISCARD}

var stacks: Array[Potion_Stack] = [
	Potion_Stack.new(),
	Potion_Stack.new(),
	Potion_Stack.new()
]

func add_to_stack(stack_index: int, potion: PotionData) -> void:
	stacks[stack_index].add_potion(potion)

func discard_potion(stack_index: int) -> void:
	stacks[stack_index].discard_potion()
