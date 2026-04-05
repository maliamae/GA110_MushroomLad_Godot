extends Node

var player 
var isPlayerDead := false
#@onready var respawn_screen: CanvasLayer = $respawn_screen

signal player_respawned
signal player_died

func _ready() -> void:
	player_respawned.connect(CheckpointManager.respawn_player)

func store_body(body):
	player = body

func pass_signal():
	isPlayerDead = true
	emit_signal("player_died")

func respawn_player():
	#respawn player at respawn point established in checkpoint manager
	await get_tree().create_timer(.5).timeout
	#get_tree().reload_current_scene()
	#send signal to checkpoint manager
	player.isDead = false
	emit_signal("player_respawned")
	player.global_position = CheckpointManager.respawn_pos
