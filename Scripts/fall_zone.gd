extends Area3D

#signal to notify checkpoint manager when player is respawned
#signal player_respawned
signal player_died(player)
signal player_drowned

func _ready() -> void:
	#connect signal
	#player_respawned.connect(CheckpointManager.respawn_player)
	player_died.connect(RespawnManager.store_body)
	player_drowned.connect(RespawnManager.pass_signal)


func _on_body_entered(body: Node3D) -> void:
	#kill player
	if body.name == "Player":
		await get_tree().create_timer(.25).timeout
		body.isDead = true
		#get_tree().reload_current_scene()
		emit_signal("player_died", body)
		emit_signal("player_drowned")
