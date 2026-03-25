class_name HealthBar
extends VBoxContainer

@onready var name_label: Label = $NameLabel
@onready var progress_bar: ProgressBar = $Health_Bar
@onready var hp_label: Label = $HPLabel

func setup(actor: CombatActor) -> void:
	name_label = $NameLabel
	progress_bar = $Health_Bar
	hp_label = $HPLabel
	name_label.text = actor.actor_name
	progress_bar.max_value = actor.max_hp
	progress_bar.value = actor.max_hp
	hp_label.text = "%d / %d" % [actor.max_hp, actor.max_hp]
	actor.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(new_hp: int, max_hp: int) -> void:
	progress_bar.value = new_hp
	hp_label.text = "%d / %d" % [new_hp, max_hp]
