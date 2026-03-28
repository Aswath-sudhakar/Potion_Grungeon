class_name EnemyActor
extends CombatActor

@export var attack: int = 10
@export var Weaknesses: Array[int] = []
@export var Resistances: Array[int] = []
@export var enemy_loot: LootPool
var next_attack: int  

signal intent_changed(damage: int)

func _ready() -> void:
	super._ready()
	generate_intent()

func generate_intent() -> void:
	next_attack = attack
	intent_changed.emit(next_attack)

func take_turn(target: CombatActor) -> void:
	print(actor_name, " attacks for ", next_attack, " damage!")
	target.take_damage(next_attack)
	generate_intent()  # show next turn's attack immediately after

func get_damage_multiplier(damage_type: DamageType.Type) -> float:
	print("check damage type",damage_type)
	print("Weaknesses",Weaknesses)
	print("Resist",Resistances)
	if damage_type in Weaknesses:
		print("Weakness Found!")
		return 1.5
	if damage_type in Resistances:
		print("Resistance Found!")
		return 0.5
	return 1.0
	
func get_drops() -> Array[Item]:
	if enemy_loot == null:
		return []
	return enemy_loot.roll_drops()
		
