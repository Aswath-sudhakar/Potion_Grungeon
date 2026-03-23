class_name CraftingScreen
extends Control

@onready var slot_2: Panel = $CraftingSlots/Slot2
@onready var slot: Panel = $CraftingSlots/Slot

@onready var result_slot: Panel = $ResultSlot

@onready var craft_button: Button = $CraftButton
@onready var result_label: Label = $ResultLabel

var crafting_manager: CraftingManager

func _ready() -> void:
	print("CraftingScreen ready!")
	print("Craft button: ", craft_button)
	crafting_manager = CraftingManager.new()
	crafting_manager.recipies = _load_recipies()
	craft_button.pressed.connect(_on_craft_button_pressed)

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
