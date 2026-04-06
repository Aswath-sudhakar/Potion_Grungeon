extends Node2D



@onready var map_buttons: Array = [
	$Button,
	$Button2,
	$Button3,
	$Button4,
	$Button5,
	$Button6,
	$Button7,
]

func _ready() -> void:
	print("Map ready, current node: ", GameState.current_map_node)
	_update_buttons()
	for i in map_buttons.size():
		var btn = map_buttons[i]
		var index = i
		btn.pressed.connect(func(): _on_node_pressed(index))

func _update_buttons() -> void:
	for i in map_buttons.size():
		var btn = map_buttons[i]
		if i < GameState.current_map_node:
			# already visited
			btn.disabled = true
			btn.modulate = Color(0.4, 0.4, 0.4)
		elif i == GameState.current_map_node:
			# current available node
			btn.disabled = false
			btn.modulate = Color(1, 1, 1)
		else:
			# not yet reachable
			btn.disabled = true
			btn.modulate = Color(0.6, 0.6, 0.6)

func _on_node_pressed(index: int) -> void:
	GameState.current_map_node = index + 1
	print("Node pressed: ", index)
	print("New map node: ", GameState.current_map_node)
	var game_save = GameSave.load_or_create()
	print("Saved map node: ", game_save.current_map_node)
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")
	
func _on_craft_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("uid://bgyafitn0pjn1"))
