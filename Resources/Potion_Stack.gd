class_name Potion_Stack
extends Resource

var potions: Array[PotionData] = []
const MAX_SIZE = 10

func can_use() -> bool:
	return potions.size() > 0

func peek_top() -> PotionData:
	if can_use():
		return potions[0]
	return null

func use_top(action: Potion_manager.PotionAction, user: CombatActor, target: CombatActor) -> PotionData:
	if not can_use():
		return null
	var potion = potions.pop_front()  
	potion.execute(action, user, target)
	return potion

func discard_potion() -> void:
	if can_use():
		potions.pop_front()

func move_potion(from_index: int, to_index: int) -> void:
	if from_index == to_index:
		return
	if from_index < 0 or from_index >= potions.size():  
		return
	if to_index < 0 or to_index >= potions.size():
		return
	var potion = potions[from_index]
	potions.remove_at(from_index)
	potions.insert(to_index, potion)

func add_potion_to_diff_stack(from_stack: Potion_Stack, from_index: int, to_index: int) -> void:
	if from_stack.potions.is_empty():
		return
	if potions.size() >= MAX_SIZE:
		return
	var potion = from_stack.potions[from_index]
	from_stack.potions.remove_at(from_index)
	potions.insert(to_index, potion)

func add_potion(potion: PotionData) -> bool:  
	if potions.size() >= MAX_SIZE:  
		return false
	potions.push_back(potion)  
	return true
