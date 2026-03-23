class_name combat_manager
extends Node

@onready var player: PlayerActor = $"../PlayerActor"
@onready var enemy: EnemyActor = $"../EnemyActor"
@onready var combat_ui: CombatUI = $"../Combat_UI"
@onready var Turn_manager: TurnManager = TurnManager.new()
@onready var potion_label = $"../PlayerActor/PotionUseCount"
var potion_manager: Potion_manager
var turn_manager: TurnManager

@export var starting_potions: Array[PotionData] = []

func _ready() -> void:
	potion_manager = Potion_manager.new()
	turn_manager = TurnManager.new()
	add_child(turn_manager)
	print("created turn_manager at: ", turn_manager.get_path())
	await get_tree().process_frame
	_deal_starting_potions()
	# connect signals
	turn_manager.turn_changed.connect(_on_turn_changed)
	turn_manager.combat_ended.connect(_on_combat_ended)
	player.died.connect(_on_player_died)
	enemy.died.connect(_on_enemy_died)
	combat_ui.setup(self)
	turn_manager.start_combat()
	turn_manager.potion_use_count = player.get_node("PotionUseCount")
	print("potion label assigned: ", turn_manager.potion_use_count)

func _deal_starting_potions() -> void:
	if starting_potions.is_empty():
		print("No starting potions assigned!")
		return
	for i in starting_potions.size():
		var stack_index = i % 3
		potion_manager.stacks[stack_index].add_potion(starting_potions[i])

func use_potion(stack_index: int, action: Potion_manager.PotionAction) -> void:
	if not turn_manager.can_use_potion():
		print("Cannot use potion right now!")
		return
	var stack = potion_manager.stacks[stack_index]
	if not stack.can_use():
		return
	stack.use_top(action, player, enemy)
	print("enemy status effects after potion", enemy.Status_effects.size())
	turn_manager.on_potion_used()
	if not turn_manager.check_combat_end(player, enemy):
		combat_ui.refresh_all()

func end_player_turn() -> void:
	turn_manager.end_player_turn()
	# small delay before enemy acts so player can see what happened
	await get_tree().create_timer(0.5).timeout
	_run_enemy_turn()

func _run_enemy_turn() -> void:
	enemy.process_status()
	
	if not turn_manager.check_combat_end(player, enemy):
		enemy.take_turn(player)
		
		if not turn_manager.check_combat_end(player, enemy):
			player.process_status()
			
			if not turn_manager.check_combat_end(player, enemy):
				turn_manager.end_enemy_turn()
				combat_ui.refresh_all()

func _on_turn_changed(new_state: TurnManager.TurnState) -> void:
	combat_ui.on_turn_changed(new_state)

func _on_combat_ended(player_won: bool) -> void:
	print("Combat ended! Player won: ", player_won)

func _on_player_died() -> void:
	turn_manager.check_combat_end(player, enemy)

func _on_enemy_died() -> void:
	turn_manager.check_combat_end(player, enemy)
