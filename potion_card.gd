class_name PotionCard
extends PanelContainer

var name_label: Label

func setup(potion: PotionData, is_top: bool) -> void:
	if name_label == null:
		name_label = $Name
	name_label.text = potion.PotionType
	modulate = Color(1, 1, 1) if is_top else Color(0.5, 0.5, 0.5)
