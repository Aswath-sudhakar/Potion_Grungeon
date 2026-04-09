extends Panel

@onready var icon: TextureRect = $Icon
@onready var amount: Label = $Amount
var dragged_item: Item = null
var dragged_amount: int = 0

var hover_size := Vector2(1.5,1.5)
var normal_size := Vector2(1,1)

@export var item: Item = null:
	set(value):
		item = value
		if not is_node_ready():
			return
		update_display()

@export var Amount: int = 0:
	set(value):
		Amount = value
		if not is_node_ready():
			return
		amount.text = str(Amount) if Amount > 0 else ""
		if Amount <= 0:
			item = null

func _ready() -> void:
	pivot_offset = size / 2
	update_display()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func receive_item(new_item: Item, new_amount: int) -> void:
	if not is_node_ready():
		await ready
	item = new_item
	Amount = new_amount
	icon.texture = new_item.Icon if new_item != null else null
	amount.text = str(new_amount) if new_amount > 0 else ""

func update_display() -> void:
	if icon == null or amount == null:
		return
	if item == null:
		icon.texture = null
		amount.text = ""
	else:
		icon.texture = item.Icon
		amount.text = str(Amount) if Amount > 0 else ""

func set_amount(value: int) -> void:
	Amount = value

func add_amount(value: int) -> void:
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
	else:
		data.source.item = null
		data.source.Amount = 0

func _get_drag_data(at_position):
	if not item:
		return null
	dragged_item = item
	dragged_amount = Amount
	if item:
		var preview_texture = TextureRect.new()
		preview_texture.texture = item.Icon
		preview_texture.position = -Vector2(10, 10)
		preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var preview = Control.new()
		preview.add_child(preview_texture)
		set_drag_preview(preview)
		preview_texture.call_deferred("set_size", Vector2(36, 36))
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
		
func _on_mouse_entered():
	print("hovered")
	var tween = create_tween()
	tween.tween_property(self, "scale", hover_size, 0.15)

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", normal_size, 0.15)
				
