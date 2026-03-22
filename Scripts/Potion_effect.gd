class_name PotionEffect
extends Resource

enum EffectType { DAMAGE, HEAL, BUFF, DEBUFF }

@export var effect_type: EffectType
@export var value: int
@export var stat_target: String
