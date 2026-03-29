class_name CraftingScreen
extends Control

@onready var slot_2: Panel = $CraftingSlots/Slot2
@onready var slot: Panel = $CraftingSlots/Slot

@onready var result_slot: Panel = $ResultSlot

@onready var craft_button: Button = $CraftButton
@onready var result_label: Label = $ResultLabel

var crafting_manager: CraftingManager
var inventory_manager: Inventory_manager

func _ready() -> void:
	print("CraftingScreen ready!")
	print("Craft button: ", craft_button)
	crafting_manager = CraftingManager.new()
	crafting_manager.recipies = _load_recipies()
	craft_button.pressed.connect(_on_craft_button_pressed)
	load_pending_drops()

func setup(p_inventory_manager: Inventory_manager, drops: Array):
	inventory_manager = p_inventory_manager
	
	var inventory_node = $Inventory
	
	var inventory_slots = inventory_node.get_children()
	inventory_manager.setup(inventory_slots)

func _on_craft_button_pressed() -> void:
	print("banana")
	if slot.item == null or slot_2.item == null:
		result_label.text = "Need 2 ingredients!"
		return
	if not crafting_manager.can_craft(slot.item, slot_2.item):
		result_label.text = "No recipe found!"
		return
	var potion = crafting_manager.craft(slot.item, slot_2.item)
	# clear ingredient slots
	
	slot.Amount -= 1
	
	slot_2.Amount -= 1
	# show result
	result_label.text = "Crafted: " + potion.PotionType	
	# add potion to potion inventory here
	# PotionInventory.add_potion(potion)
func _load_recipies() -> Array[Recipies]:
	var recipies: Array[Recipies] = []
	var dir = DirAccess.open("res://Resources/Recipies/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				var recipe = load("res://Resources/Recipies/" + file)
				if recipe is Recipies:
					recipies.append(recipe)
			file = dir.get_next()
	return recipies
	
func load_pending_drops() -> void:
	print("Checking for pending drops...")
	print("File exists: ", FileAccess.file_exists("user://pending_drops.tres"))
	print("User dir: ", OS.get_user_data_dir())
	
	if not FileAccess.file_exists("user://pending_drops.tres"):
		print("no pend drops found")
		
	var drop_data = ResourceLoader.load("user://pending_drops.tres")
	if drop_data == null:
		print("Failed to load drop data")
		return
	print("Drop data loaded, drops: ", drop_data.drops.size())
	var inv_slots = $Inventory/UI/GridContainer.get_children()
	print("Inventory slots found: ", inv_slots.size())
	for drop in drop_data.drops:
		print("Adding drop: ", drop)
		_add_item_to_inventory(drop, inv_slots)
	
	DirAccess.remove_absolute("user://pending_drops.tres")
	
func _add_item_to_inventory(new_item: Item, slots: Array) -> void:
	for slot in slots:
		if slot.item == new_item:
			slot.receive_item(new_item, slot.Amount + 1)
			return
	for slot in slots:
		if slot.item == null:
			slot.receive_item(new_item, 1)
			return
