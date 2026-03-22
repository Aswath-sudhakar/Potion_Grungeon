class_name TurnManager
extends Node

enum TurnState { PLAYER_TURN, ENEMY_TURN, COMBAT_END }

var state: TurnState = TurnState.PLAYER_TURN
var potions_used: int = 0
const MAX_POTIONS_PER_TURN = 3

signal turn_changed(new_state: TurnState)
signal potion_count_changed(count: int)
signal combat_ended(player_won: bool)

func start_combat() -> void:
	state = TurnState.PLAYER_TURN
	potions_used = 0
	turn_changed.emit(state)

func on_potion_used() -> void:
	if state != TurnState.PLAYER_TURN:
		return
	potions_used += 1
	potion_count_changed.emit(potions_used)

func can_use_potion() -> bool:
	return state == TurnState.PLAYER_TURN and potions_used < MAX_POTIONS_PER_TURN

func end_player_turn() -> void:
	if state != TurnState.PLAYER_TURN:
		return
	state = TurnState.ENEMY_TURN
	potions_used = 0
	turn_changed.emit(state)

func end_enemy_turn() -> void:
	if state != TurnState.ENEMY_TURN:
		return
	state = TurnState.PLAYER_TURN
	potions_used = 0
	turn_changed.emit(state)

func check_combat_end(player: PlayerActor, enemy: EnemyActor) -> bool:
	if not enemy.is_alive():
		state = TurnState.COMBAT_END
		combat_ended.emit(true)
		return true
	if not player.is_alive():
		state = TurnState.COMBAT_END
		combat_ended.emit(false)
		return true
	return false
