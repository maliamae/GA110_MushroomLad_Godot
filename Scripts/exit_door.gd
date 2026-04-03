extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		Transition.fade_to_scene("res://Scenes/game_over.tscn")
