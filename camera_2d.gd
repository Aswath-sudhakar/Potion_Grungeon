extends Camera2D

const speed = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_up", "ui_down")
	if direction:
		position.y += direction * speed
