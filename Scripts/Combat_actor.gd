class_name CombatActor
extends Node

var Status_effects : Array[StatusEffects] = []
@export var actor_name: String
@export var max_hp: int = 100
var current_hp: int

signal hp_changed(new_hp: int, max_hp: int)
signal died

func _ready() -> void:
	current_hp = max_hp
	
func apply_status_effects(status: StatusEffects):
	for existing in Status_effects:
		if existing.Effect_type:
			existing.initialize()
			print(actor_name, " refreshed ", StatusEffects.Type.keys()[status.Effect_type])
			return
	var new_status = status.duplicate()
	new_status.initialize()
	Status_effects.append(new_status)
	print(actor_name, "gained",StatusEffects.Type.keys()[status.Effect_type] )
	
func process_status():
	var expired = []
	for status in Status_effects:
		match status.Effect_type:
			StatusEffects.Type.POISON:
				var damage = status.tick()
				current_hp = max(0, current_hp - damage)
				print(actor_name, "took", damage,"Poision damage! (",status.turns_remaining, "turns left)")
				hp_changed.emit(current_hp, max_hp)
				if current_hp <= 0:
					died.emit()
					return
		if status.is_expired():
			expired.append(status)
	for status in expired:
		Status_effects.erase(status)
		print(actor_name, "no longer effected")
		
	
		

func take_damage(amount: int, damage_type: DamageType.Type = DamageType.Type.FIRE) -> void:
	var multiplier = 1.0
	if self is EnemyActor:
		multiplier = (self as EnemyActor).get_damage_multiplier(damage_type)
	var final_damage = max(1, int(amount * multiplier))
	print("damage taken!",final_damage)
	print(actor_name, " took ", final_damage, " damage! HP: ", current_hp, " -> ", max(0, current_hp - final_damage))
	current_hp = max(0, current_hp - final_damage)
	hp_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		died.emit()

func heal(amount: int) -> void:
	current_hp = min(max_hp, current_hp + amount)
	hp_changed.emit(current_hp, max_hp)

func is_alive() -> bool:
	return current_hp > 0
