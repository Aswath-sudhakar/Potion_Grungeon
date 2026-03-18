class_name Potion_manager
extends Node

var stacks : Array[Potion_Stack] = []

func _ready():
	for i in 3:
		stacks.append(Potion_Stack.new)
		
func use_potion(stack_index: int, action: String) -> void:
	var stack = stacks[stack_index]
	if not stack.can_use():
		return
	var used = stack.use_top(action)
	emit_signal("potion_used",stack_index,used)
	
func discard_potion(stack_index: int)-> void:
	stacks[stack_index].discard_top()
	
func add_to_stack(stack_index: int, potion: PotionData):
	if not stacks[stack_index].add_potion(potion):
		return
	pass
	
