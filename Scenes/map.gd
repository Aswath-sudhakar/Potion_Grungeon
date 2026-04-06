extends Node2D

var map_data: Dictionary = {
	0: [1, 2],
	1: [3],
	2: [3, 4],
	3: [5],
	4: [5, 6],
	5: [6],
	6: []
}

@onready var map_buttons: Array = [
	$Button,
	$Button2,
	$Button3,
	$Button4,
	$Button5,
	$Button6,
	$Button7,
]

var game_save: GameSave

func _ready() -> void:
	game_save = GameSave.load_or_create()
	print("Map ready, available nodes: ", game_save.available_nodes)
	_update_buttons()
	for i in map_buttons.size():
		var btn = map_buttons[i]
		var index = i
		btn.pressed.connect(func(): _on_node_pressed(index))

func _update_buttons() -> void:
	for i in map_buttons.size():
		var btn = map_buttons[i]
		if i in game_save.visited_nodes:
			btn.disabled = true
			btn.modulate = Color(0.4, 0.4, 0.4)
		elif i in game_save.available_nodes:
			btn.disabled = false
			btn.modulate = Color(1, 1, 1)
		else:
			btn.disabled = true
			btn.modulate = Color(0.6, 0.6, 0.6)

func _on_node_pressed(index: int) -> void:
	print("Node pressed: ", index)
	if index not in game_save.visited_nodes:
		game_save.visited_nodes.append(index)
	game_save.available_nodes.clear()
	if map_data.has(index):
		for connected in map_data[index]:
			game_save.available_nodes.append(connected)
	game_save.current_map_node = index
	game_save.save()
	GameState.is_boss_fight = map_data[index].is_empty()
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")
	
