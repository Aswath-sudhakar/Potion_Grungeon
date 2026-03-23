extends Panel
@onready var icon: TextureRect = $Icon
@onready var amount: Label = $Amount
const ICON = preload("uid://dlj04miipohcf")



@export var item : Item = null: 
		set(value):
			item = value 
			
			if not is_node_ready():
				return
			
			if value == null:
				icon.texture = null
				amount.text = ""
				return
				
			icon.texture = ICON
			
@export var Amount : int = 0:
	set(value):
		Amount = value
		if not is_node_ready():
				return
		
		amount.text = str(value)
		if Amount <= 0:
			item = null
			
func set_amount(value: int):
	Amount = value
	
func add_amount(value: int):
	Amount += value
	
func _can_drop_data(at_position, data):
	if "item" in data:
		return is_instance_of(data.item, Item)
	return false

func _drop_data(at_position, data):
	var temp = item
	var temp_amount
	
	item = data.item
	Amount = data.amount
	
	if temp != null:
		data.source.item = temp
		data.source.Amount = temp_amount
	
func _get_drag_data(at_position):
	var data = {
		"item": item,
		"amount": Amount,
		"source": self
		
	}
	item = null
	Amount = 0
	return data

				
