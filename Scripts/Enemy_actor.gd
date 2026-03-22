class_name EnemyActor
extends CombatActor

@export var attack: int = 10

var next_attack: int  # telegraphed damage value

signal intent_changed(damage: int)

func _ready() -> void:
	super._ready()
	generate_intent()

func generate_intent() -> void:
	# for now just use attack stat, later you can randomize
	next_attack = attack
	intent_changed.emit(next_attack)

func take_turn(target: CombatActor) -> void:
	target.take_damage(next_attack)
	generate_intent()  # show next turn's attack immediately after
