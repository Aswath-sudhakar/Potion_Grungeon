class_name GameSave
extends Resource

@export var ingredient_slots: Array = []  # Array of {item, amount} dicts
@export var stack_0: Array = []           # Array of PotionData
@export var stack_1: Array = []
@export var stack_2: Array = []

const SAVE_PATH = "user://game_save.tres"

static func load_or_create() -> GameSave:
	if FileAccess.file_exists(SAVE_PATH):
		var save = ResourceLoader.load(SAVE_PATH)
		if save != null:
			return save
	return GameSave.new()

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)
