class_name CombatUI
extends Control

var stack_uis: Array = []
var combat_manager: combat_manager
var selected_index: int = -1

func setup(p_combat_manager: combat_manager) -> void:
	combat_manager = p_combat_manager
	# fetch nodes here instead of @onready
	stack_uis = [
		$PotionRow/StackUI0,
		$PotionRow/StackUI1,
		$PotionRow/StackUI2,
	]
	for ui in stack_uis:
		ui.stack_selected.connect(_on_stack_selected)
	refresh_all()

func _on_stack_selected(index: int) -> void:
	if selected_index == index:
		stack_uis[index].deselect()
		selected_index = -1
		return
	if selected_index != -1:
		stack_uis[selected_index].deselect()
	selected_index = index
	stack_uis[index].set_selected(true)

func refresh_all() -> void:
	for i in 3:
		stack_uis[i].refresh(combat_manager.potion_manager.stacks[i], combat_manager)
	if selected_index != -1:
		stack_uis[selected_index].set_selected(true)
