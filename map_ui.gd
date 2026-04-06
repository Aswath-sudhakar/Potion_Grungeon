class_name MapUI
extends Control

var buttons: Array = []
var next_button: int = 0


func _ready() -> void:
	buttons = [
		$Button,
		$Button2,
		$Button3,
		$Button4,
		$Button5,
		$Button6,
		$Button7
	]
	for button in buttons:
		button.pressed.connect(_start_battle)

func _procces(delta: float) -> void:
	var combatManager: combat_manager = $CombatManager
	if combatManager != null:	
		combatManager.combat_ended.connect(_on_battle_over)
	

func _start_battle() -> void:
	print("pressed")
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")
	
func _on_battle_over(player_won: bool) -> void:
	print("Battle Over")
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
	if player_won:
		next_button += 1
		buttons[next_button].set_disabled(false)
