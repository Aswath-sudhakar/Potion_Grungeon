extends Resource
class_name StatusEffects


enum  Type{POISON, BURN}

@export var Duration : int 
@export var Effect_type: Type 
@export var Base_damage: int 
var current_value : int
var turns_remaining : int 

func initialize(): 
	current_value = Base_damage
	turns_remaining = Duration
	
func tick():
	var damage = current_value
	current_value = max(0, current_value - 1)
	turns_remaining -= 1 
	return damage
	
func is_expired() -> bool:
	return turns_remaining <= 0
