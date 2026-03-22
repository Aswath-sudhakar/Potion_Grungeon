class_name combat_manager
extends Node

@onready var player: PlayerActor = $"../PlayerActor"
@onready var enemy: EnemyActor = $"../EnemyActor"
@onready var combat_ui: CombatUI = $"../Combat_UI"

var potion_manager: Potion_manager

@export var starting_potions: Array[PotionData] = []

func _ready() -> void:
	potion_manager = Potion_manager.new()
	print("Stack count: ", potion_manager.stacks.size())
	_deal_starting_potions()
	combat_ui.setup(self)

func _deal_starting_potions() -> void:
	if starting_potions.is_empty():
		print("No starting potions assigned!")
		return
	for i in starting_potions.size():
		var stack_index = i % 3
		potion_manager.stacks[stack_index].add_potion(starting_potions[i])

func use_potion(stack_index: int, action: Potion_manager.PotionAction) -> void:
	var stack = potion_manager.stacks[stack_index]
	if not stack.can_use():
		return
	stack.use_top(action, player, enemy)  # use_top calls execute internally
	combat_ui.refresh_all()
