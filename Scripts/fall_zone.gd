extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		#get_tree().reload_current_scene()
		call_deferred("reset_scene")

func reset_scene():
	await get_tree().create_timer(.5).timeout
	get_tree().reload_current_scene()
