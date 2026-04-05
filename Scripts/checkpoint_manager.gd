extends Node

var respawn_pos : Vector3
var saved_rays := 0

var type : CollectibleManager.CollectibleType
var amount 

#signal to notify collectible manager of a new checkpoint being established
signal checkpoint_updated
#signal that passes values of collectible type and amount to collectible manager to reset the collectible amount to the amount saved at last checkpoint
signal reset_rays(type, amount)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_updated.connect(CollectibleManager.reset_stored_list)
	reset_rays.connect(CollectibleManager.set_amount)

func set_new_checkpoint(pos : Vector3, amount : int):
	#stores checkpoint info as respawn position and number of collectibles to be respawned with
	respawn_pos = pos
	saved_rays = amount
	emit_signal("checkpoint_updated")

func reset():
	#resets scene with original respawn point at beginning of level
	await get_tree().create_timer(.5).timeout
	respawn_pos = Vector3(0.0, 3.956, -1.4)
	saved_rays = 0
	emit_signal("reset_rays", CollectibleManager.CollectibleType.ORB, saved_rays)

func respawn_player():
	#when triggered, signals to collectible manager to reset to saved number of collectibles
	emit_signal("reset_rays", CollectibleManager.CollectibleType.ORB, saved_rays)
