class_name CraftingScreen
extends Control

var crafting_manager: CraftingManager
var game_save: GameSave

@onready var craft_button: Button = $CraftButton
@onready var result_label: Label = $ResultLabel
@onready var slot = $CraftingSlots/Slot
@onready var slot_2 = $CraftingSlots/Slot2

func _ready() -> void:
	print("CraftingScreen ready!")
	crafting_manager = CraftingManager.new()
	crafting_manager.recipies = _load_recipies()
	craft_button.pressed.connect(_on_craft_button_pressed)
	game_save = GameSave.load_or_create()
	print("Inventory node: ", $Inventory/UI/GridContainer)
	print("Stack0 node: ", $PotionStacks/HBoxContainer/Stack0)
	print("Stack1 node: ", $PotionStacks/HBoxContainer/Stack1)
	print("Stack2 node: ", $PotionStacks/HBoxContainer/Stack2)
	_load_pending_drops()
	_populate_ingredient_inventory()
	_populate_potion_stacks()

func _populate_ingredient_inventory() -> void:
	var inv_slots = $Inventory/UI/GridContainer.get_children()
	for i in game_save.ingredient_slots.size():
		if i >= inv_slots.size():
			break
		var entry = game_save.ingredient_slots[i]
		if entry.item != null:
			inv_slots[i].receive_item(entry.item, entry.amount)

func _populate_potion_stacks() -> void:
	var stack_columns = [
		$PotionStacks/HBoxContainer/Stack0,
		$PotionStacks/HBoxContainer/Stack1,
		$PotionStacks/HBoxContainer/Stack2
	]
	var all_stacks = [game_save.stack_0, game_save.stack_1, game_save.stack_2]
	for col in 3:
		var slots = stack_columns[col].get_children()
		for i in all_stacks[col].size():
			if i >= slots.size():
				break
			var potion_item = all_stacks[col][i]
			if potion_item != null:
				slots[i].receive_item(potion_item, 1)

func _save_state() -> void:
	# save ingredient inventory
	game_save.ingredient_slots.clear()
	var inv_slots = $Inventory/UI/GridContainer.get_children()
	for slot_node in inv_slots:
		game_save.ingredient_slots.append({
			"item": slot_node.item,
			"amount": slot_node.Amount
		})
	# save potion stacks
	game_save.stack_0 = _read_stack($PotionStacks/HBoxContainer/Stack0)
	game_save.stack_1 = _read_stack($PotionStacks/HBoxContainer/Stack1)
	game_save.stack_2 = _read_stack($PotionStacks/HBoxContainer/Stack2)
	game_save.save()

func _read_stack(stack_node: Node) -> Array:
	var potions = []
	for slot_node in stack_node.get_children():
		if slot_node.item != null and slot_node.item.potion_data != null:
			potions.append(slot_node.item)
	return potions

func _on_craft_button_pressed() -> void:
	print("Craft button pressed!")
	if slot.item == null or slot_2.item == null:
		result_label.text = "Need 2 ingredients!"
		return
	if not crafting_manager.can_craft(slot.item, slot_2.item):
		result_label.text = "No recipe found!"
		return
	var crafted_item = crafting_manager.craft(slot.item, slot_2.item)
	if crafted_item == null:
		result_label.text = "Craft failed!"
		return
	slot.Amount -= 1
	slot_2.Amount -= 1
	# add crafted potion to potion inventory not ingredient inventory
	var stack_slots = _get_all_stack_slots()
	_add_item_to_inventory(crafted_item, stack_slots)
	result_label.text = "Crafted: " + crafted_item.title

func _get_all_stack_slots() -> Array:
	var slots = []
	for stack in [$PotionStacks/HBoxContainer/Stack0, $PotionStacks/HBoxContainer/Stack1, $PotionStacks/HBoxContainer/Stack2]:
		for slot_node in stack.get_children():
			slots.append(slot_node)
	return slots

func _on_start_combat_pressed() -> void:
	_save_state()
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

func _load_pending_drops() -> void:
	if GameState.pending_drops.is_empty():
		print("No pending drops")
		return
	print("Loading ", GameState.pending_drops.size(), " drops")
	var inv_slots = $Inventory/UI/GridContainer.get_children()
	for drop in GameState.pending_drops:
		_add_item_to_inventory(drop, inv_slots)
	GameState.pending_drops.clear()
func _add_item_to_inventory(new_item: Item, slots: Array) -> void:
	for slot_node in slots:
		if slot_node.item == new_item:
			slot_node.receive_item(new_item, slot_node.Amount + 1)
			return
	for slot_node in slots:
		if slot_node.item == null:
			slot_node.receive_item(new_item, 1)
			return
	print("Inventory full!")

func _load_recipies() -> Array:
	var recipes: Array = []
	var dir = DirAccess.open("res://Resources/Recipies/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				var recipe = load("res://Resources/Recipies/" + file)
				if recipe is Recipies:
					recipes.append(recipe)
			file = dir.get_next()
	return recipes
	
