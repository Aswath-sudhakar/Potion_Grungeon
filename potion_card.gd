class_name PotionCard
extends PanelContainer

var name_label: Label
var texture_rect: TextureRect 

func setup(potion: PotionData, is_top: bool) -> void:
	
	if name_label == null:
		name_label = $Name
	if texture_rect == null:
		texture_rect = $TextureRect
	print("texture_rect: ", texture_rect)
	print("potion sprite: ", potion.Sprite)
	texture_rect.texture = potion.Sprite
	modulate = Color(1, 1, 1) if is_top else Color(0.5, 0.5, 0.5)
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	modulate = Color(1, 1, 1) if is_top else Color(0.5, 0.5, 0.5)
