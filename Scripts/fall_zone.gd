extends Area3D

signal player_respawned

func _ready() -> void:
	player_respawned.connect(CheckpointManager.respawn_player)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		#get_tree().reload_current_scene()
		call_deferred("respawn_player", body)

func respawn_player(body):
	await get_tree().create_timer(.5).timeout
	#get_tree().get_node("Player").global_position = CheckpointManager.respawn_pos
	#get_tree().get_root().get_node("Player").global_position = CheckpointManager.respawn_pos
	#get_tree().reload_current_scene()
	emit_signal("player_respawned")
	body.global_position = CheckpointManager.respawn_pos
