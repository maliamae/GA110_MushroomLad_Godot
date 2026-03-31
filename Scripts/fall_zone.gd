extends Area3D

#signal to notify checkpoint manager when player is respawned
signal player_respawned

func _ready() -> void:
	#connect signal
	player_respawned.connect(CheckpointManager.respawn_player)

func _on_body_entered(body: Node3D) -> void:
	#kill player
	if body.name == "Player":
		#get_tree().reload_current_scene()
		call_deferred("respawn_player", body)

func respawn_player(body):
	#respawn player at respawn point established in checkpoint manager
	await get_tree().create_timer(.5).timeout
	#get_tree().reload_current_scene()
	#send signal to checkpoint manager
	emit_signal("player_respawned")
	body.global_position = CheckpointManager.respawn_pos
