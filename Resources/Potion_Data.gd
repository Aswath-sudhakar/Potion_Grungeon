class_name PotionData
extends Resource

@export var drink_effects: Array[PotionEffect] = []
@export var throw_effects: Array[PotionEffect] = []
@export var PotionType: String 
@export var Sprite: Texture2D

func execute(action: Potion_manager.PotionAction, user: CombatActor, target: CombatActor) -> void:
	match action:
		Potion_manager.PotionAction.DRINK:
			_apply_drink_effect(user)
		Potion_manager.PotionAction.THROW:
			_apply_throw_effect(target)

func _apply_drink_effect(user: CombatActor) -> void:
	for effect in drink_effects:
		match effect.effect_type:
			PotionEffect.EffectType.HEAL:
				user.heal(effect.value)
			PotionEffect.EffectType.BUFF:
				user.apply_buff(effect.stat_target, effect.value)
			PotionEffect.EffectType.DAMAGE:
				user.take_damage(effect.value)
			PotionEffect.EffectType.DEBUFF:
				user.apply_buff(effect.stat_target, -effect.value)
			PotionEffect.EffectType.STATUS:
				user.apply_status_effects(effect.status_to_apply)
func _apply_throw_effect(target: CombatActor) -> void:
	print("Throwing at: ", target)
	for effect in throw_effects:
		match effect.effect_type:
			PotionEffect.EffectType.DAMAGE:
				target.take_damage(effect.value, effect.damage_type)
			PotionEffect.EffectType.DEBUFF:
				target.apply_buff(effect.stat_target, -effect.value)
			PotionEffect.EffectType.HEAL:
				target.heal(effect.value)
			PotionEffect.EffectType.BUFF:
				target.apply_buff(effect.stat_target, effect.value)
			PotionEffect.EffectType.STATUS:
				target.apply_status_effects(effect.status_to_apply)
			
