class_name CombatActor
extends Node

@export var actor_name: String
@export var max_hp: int = 100
var current_hp: int

signal hp_changed(new_hp: int, max_hp: int)
signal died

func _ready() -> void:
	current_hp = max_hp

func take_damage(amount: int) -> void:
	current_hp = max(0, current_hp - amount)
	hp_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		died.emit()

func heal(amount: int) -> void:
	current_hp = min(max_hp, current_hp + amount)
	hp_changed.emit(current_hp, max_hp)

func is_alive() -> bool:
	return current_hp > 0
