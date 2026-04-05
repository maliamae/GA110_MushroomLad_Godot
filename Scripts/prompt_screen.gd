extends CanvasLayer


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		destroy_screen()

func destroy_screen():
	queue_free()
