class_name PotionData
extends Resource

@export var PotionEffect: String
@export var PotionDamage: int 
@export var PotionType: String 
@export var Sprite: Texture2D

func execute(action: String) -> void:
	match action:
		"drink":
			Drink()
		
		"throw":
			Throw()
			
func Drink():
	pass
	
func Throw(): 
	pass
