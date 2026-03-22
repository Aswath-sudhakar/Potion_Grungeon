class_name CombatUI
extends Control

var stack_uis: Array = []
var Combat_manager: combat_manager
var selected_index: int = -1
var end_turn_btn: Button

func setup(p_combat_manager: combat_manager) -> void:
	Combat_manager = p_combat_manager
	stack_uis = [
		$PotionRow/StackUI0,
		$PotionRow/StackUI1,
		$PotionRow/StackUI2,
	]
	end_turn_btn = $EndTurnButton
	end_turn_btn.pressed.connect(_on_end_turn_pressed)
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
		stack_uis[i].refresh(Combat_manager.potion_manager.stacks[i], Combat_manager)
	if selected_index != -1:
		stack_uis[selected_index].set_selected(true)

func on_turn_changed(state: TurnManager.TurnState) -> void:
	match state:
		TurnManager.TurnState.PLAYER_TURN:
			end_turn_btn.disabled = false
		TurnManager.TurnState.ENEMY_TURN:
			end_turn_btn.disabled = true
		TurnManager.TurnState.COMBAT_END:
			end_turn_btn.disabled = true

func _on_end_turn_pressed() -> void:
	Combat_manager.end_player_turn()
