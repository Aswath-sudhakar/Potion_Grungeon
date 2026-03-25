class_name PotionEffect
extends Resource

enum EffectType { DAMAGE, HEAL, BUFF, DEBUFF, STATUS}

@export var effect_type: EffectType
@export var value: int
@export var stat_target: String
@export var damage_type: DamageType.Type
@export var status_to_apply: StatusEffects
