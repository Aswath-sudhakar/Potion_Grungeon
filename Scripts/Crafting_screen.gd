class_name CraftingScreen
extends Control

@onready var slot_2: Panel = $CraftingSlots/Slot2
@onready var slot: Panel = $CraftingSlots/Slot

@onready var result_slot: Panel = $ResultSlot

@onready var craft_button: Button = $CraftButton
@onready var result_label: Label = $ResultLabel



var crafting_manager: CraftingManager

func _ready() -> void:
	crafting_manager = CraftingManager.new()
	craft_button.pressed.connect(_on_craft_pressed)

func _on_craft_pressed() -> void:
	if slot.item == null or slot_2.item == null:
		result_label.text = "Need 2 ingredients!"
		return
	if not crafting_manager.can_craft(slot.item, slot_2.item):
		result_label.text = "No recipe found!"
		return
	var potion = crafting_manager.craft(slot.item, slot_2.item)
	# clear ingredient slots
	slot.item = null
	slot.Amount = 0
	slot_2.item = null
	slot_2.Amount = 0
	# show result
	result_label.text = "Crafted: " + potion.PotionType
	# add potion to potion inventory here
	# PotionInventory.add_potion(potion)
