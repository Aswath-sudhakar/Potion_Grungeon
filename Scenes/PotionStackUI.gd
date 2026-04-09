class_name PotionStackUI
extends PanelContainer

signal stack_selected(index: int)

@export var stack_index: int

var card_list: Node
var action_btns: Node
var drink_btn: Button
var throw_btn: Button
var stack: Potion_Stack
var Combat_manager: combat_manager

func _ready() -> void:
	
	_fetch_nodes()
	action_btns.hide()
	drink_btn.pressed.connect(_on_drink_pressed)
	throw_btn.pressed.connect(_on_throw_pressed)
	gui_input.connect(_on_gui_input)

func _fetch_nodes() -> void:
	card_list = $VBoxContainer/Potion_cards
	action_btns = $VBoxContainer/Action_buttons
	drink_btn = $VBoxContainer/Action_buttons/Drink_button
	throw_btn = $VBoxContainer/Action_buttons/Throw_button

func refresh(p_stack: Potion_Stack, p_combat_manager: combat_manager) -> void:
	stack = p_stack
	Combat_manager = p_combat_manager
	if card_list == null:
		_fetch_nodes()
		action_btns.hide()
		drink_btn.pressed.connect(_on_drink_pressed)
		throw_btn.pressed.connect(_on_throw_pressed)
		gui_input.connect(_on_gui_input)
	for child in card_list.get_children():
		child.queue_free()
	for i in stack.potions.size():
		var potion = stack.potions[i]
		var card = preload("res://Scenes/potion_card.tscn").instantiate()
		card.setup(potion, i == 0)
		card_list.add_child(card)
		card.position = Vector2(35, i * 5)
		card.z_index = stack.potions.size() - i
	card_list.custom_minimum_size = Vector2(80, 120)
	if not stack.can_use():
		deselect()

func set_selected(value: bool) -> void:
	if value and stack.can_use():
		action_btns.show()
	else:
		action_btns.hide()

func deselect() -> void:
	set_selected(false)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		stack_selected.emit(stack_index)

func _on_drink_pressed() -> void:
	if stack.can_use():
		Combat_manager.use_potion(stack_index, Potion_manager.PotionAction.DRINK)

func _on_throw_pressed() -> void:
	if stack.can_use():
		Combat_manager.use_potion(stack_index, Potion_manager.PotionAction.THROW)
