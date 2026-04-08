class_name combat_manager
extends Node

@onready var player: Player_Actor = $"../PlayerActor"
@export var encounter_pool: EncounterPool
@onready var enemy: EnemyActor = $"../EnemyActor"
@onready var combat_ui: CombatUI = $"../Combat_UI"
@onready var Turn_manager: TurnManager = TurnManager.new()
@onready var potion_label = $"../PlayerActor/PotionUseCount"
@onready var enemy_spawn_point: Node = $"../EnemySpawnPoint"
@onready var animation_player: AnimationPlayer = get_node("Transition/AnimationPlayer")
@onready var combat_anims: Combat_animations = $"../ColorRect"
@onready var stack_ui_0: PotionStackUI = $"../Combat_UI/PotionRow/StackUI0"
@onready var stack_ui_1: PotionStackUI = $"../Combat_UI/PotionRow/StackUI1"
@onready var stack_ui_2: PotionStackUI = $"../Combat_UI/PotionRow/StackUI2"
@onready var label: Label = $"../Label"

var potion_manager: Potion_manager
var turn_manager: TurnManager
var inventory_manager: Inventory_manager
var pending_drops: Array = []
var stack_items: Array = []

@export var starting_potions: Array[PotionData] = []

func _ready() -> void:

	anim_setup()
	animation_player.get_parent().get_node("ColorRect" ).color.a = 255
	animation_player.play("Fade_in")
	
	
	potion_manager = Potion_manager.new()
	turn_manager = TurnManager.new()
	add_child(turn_manager)
	LoadStackData()
	print("created turn_manager at: ", turn_manager.get_path())
	await get_tree().process_frame
	spawn_enemy()
	
	turn_manager.turn_changed.connect(_on_turn_changed)
	turn_manager.combat_ended.connect(_on_combat_ended)
	player.died.connect(_on_player_died)
	enemy.died.connect(_on_enemy_died)
	combat_ui.setup(self)
	_load_player_hp()
	turn_manager.start_combat()
	turn_manager.potion_use_count = player.get_node("PotionUseCount")
	print("potion label assigned: ", turn_manager.potion_use_count)
	await animation_player.animation_finished
	combat_anims.play_intro()
	
	combat_anims.Slide_in_out_player_turn()
	combat_anims.Potion_card_popup()
	
	await get_tree().create_timer(2).timeout
	combat_anims.slide_out_player_turn()
	combat_anims.mid_bar_vanish()
	
	
	


func _deal_starting_potions() -> void:
	if starting_potions.is_empty():
		
		return
	for i in starting_potions.size():
		var stack_index = i % 3
		potion_manager.stacks[stack_index].add_potion(starting_potions[i])

func use_potion(stack_index: int, action: Potion_manager.PotionAction) -> void:
	if not turn_manager.can_use_potion():
		
		return
	var stack = potion_manager.stacks[stack_index]
	if not stack.can_use():
		return
	stack.use_top(action, player, enemy)
	
	turn_manager.on_potion_used()
	_sync_stacks_to_save()
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
	if player_won:
		open_crafting_scene()

func _on_player_died() -> void:
	turn_manager.check_combat_end(player, enemy)

func _on_enemy_died() -> void:
	pending_drops = enemy.get_drops()
	GameState.pending_drops = pending_drops

	Turn_manager.check_combat_end(player, enemy)
	
func open_crafting_scene() -> void:
	var game_save = GameSave.load_or_create()
	print("Saving player HP: ", player.current_hp)
	game_save.player_hp = player.current_hp
	game_save.save()
	print("Saved game_save player_hp: ", game_save.player_hp)
	GameState.pending_drops = pending_drops
	get_tree().change_scene_to_packed(preload("uid://bgyafitn0pjn1"))
	
func LoadStackData() -> void:
	var game_save = GameSave.load_or_create()
	stack_items = []
	for item in game_save.stack_0:
		if item != null and item.potion_data != null:
			potion_manager.stacks[0].add_potion(item.potion_data)
			stack_items.append({"stack": 0, "item": item})
	for item in game_save.stack_1:
		if item != null and item.potion_data != null:
			potion_manager.stacks[1].add_potion(item.potion_data)
			stack_items.append({"stack": 1, "item": item})
	for item in game_save.stack_2:
		if item != null and item.potion_data != null:
			potion_manager.stacks[2].add_potion(item.potion_data)
			stack_items.append({"stack": 2, "item": item})

func _sync_stacks_to_save() -> void:
	var game_save = GameSave.load_or_create()
	game_save.stack_0.clear()
	game_save.stack_1.clear()
	game_save.stack_2.clear()
	for potion in potion_manager.stacks[0].potions:
		var matching = stack_items.filter(func(e): return e.item.potion_data == potion and e.stack == 0)
		if not matching.is_empty():
			game_save.stack_0.append(matching[0].item)
	for potion in potion_manager.stacks[1].potions:
		var matching = stack_items.filter(func(e): return e.item.potion_data == potion and e.stack == 1)
		if not matching.is_empty():
			game_save.stack_1.append(matching[0].item)
	for potion in potion_manager.stacks[2].potions:
		var matching = stack_items.filter(func(e): return e.item.potion_data == potion and e.stack == 2)
		if not matching.is_empty():
			game_save.stack_2.append(matching[0].item)	
	game_save.save()
	
func spawn_enemy():
	if encounter_pool == null:
		return 
		
	var enemy_scene = encounter_pool.get_random_enemy()
	if enemy_scene == null:
		return
	enemy = enemy_scene.instantiate()
	enemy_spawn_point.add_child(enemy)
	enemy.died.connect(_on_enemy_died)
	

func _load_player_hp() -> void:
	
	var game_save = GameSave.load_or_create()
	print("Loaded player_hp from save: ", game_save.player_hp)
	if game_save.player_hp == -1:
		print("First combat, using max hp: ", player.max_hp)
		return  
	player.current_hp = game_save.player_hp
	player.hp_changed.emit(player.current_hp, player.max_hp)
	
func anim_setup():
	label.position.x = 1500

	
