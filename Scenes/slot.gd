extends Panel
@onready var icon: TextureRect = $Icon
@onready var amount: Label = $Amount

var dragged_item: Item = null
var dragged_amount: int = 0


@export var item : Item = null: 
		set(value):
			item = value 
			
			if not is_node_ready():
				return
			
			if value == null:
				icon.texture = null
				amount.text = ""
				return
			
			icon.texture = item.Icon
			icon.size = Vector2(40, 40)	
@export var Amount : int = 0:
	set(value):
		Amount = value
		if not is_node_ready():
				return
		
		amount.text = str(value)
		if Amount <= 0:
			item = null
			
			
func _ready() -> void:
	update_display()
func update_display():
	if item == null:
		icon.texture = null
		amount.text = ""
	else:
		icon.texture = item.Icon
		amount.text = str(Amount) if Amount > 0 else "" 
		
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
	var temp_amount = Amount
	
	item = data.item
	Amount = data.amount
	
	if temp != null:
		data.source.item = temp
		data.source.Amount = temp_amount
	
func _get_drag_data(at_position):
	if not item:
		return null
		
	dragged_item = item
	dragged_amount = Amount
	
	if item:
		var preview_texture = TextureRect.new()
		
		preview_texture.texture = item.Icon
		preview_texture.position = -Vector2(10,10)
		preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var preveiw = Control.new()
		
		preveiw.add_child(preview_texture)
		set_drag_preview(preveiw)
		
		preview_texture.call_deferred("set_size", Vector2(36,36))
		
		
	var data = {
		"item": item,
		"amount": Amount,
		"source": self
		
	}
	item = null
	Amount = 0
	return data
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if not is_drag_successful() and dragged_item != null:
			item = dragged_item
			Amount = dragged_amount
		dragged_item = null
		dragged_amount = 0
				
