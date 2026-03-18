class_name Potion_Stack
extends Resource


var Potions : Array[PotionData] = []
const Max_size = 10

func can_use() -> bool:
	return Potions.size() > 0
	
func peek_top() -> PotionData:
	if can_use():
		return Potions[0]
	return null
	
func use_top(action: String) -> PotionData:
	if not can_use():
		return null
	var Potions = Potions.pop_front()
	Potions.execute(action)
	return Potions
	
func discard_potion():
	pass
	
func add_potion(Potions: PotionData) -> bool:
	if Potions.size() >= Max_size:
		return false
	Potions.push_back(PotionData)
	return true
	
		
	 
