extends Node

#var initial_respawn_pos : Vector3
var respawn_pos : Vector3
var saved_rays : int

var type : CollectibleManager.CollectibleType
var amount 

signal checkpoint_updated
signal reset_rays(type, amount)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_updated.connect(CollectibleManager.reset_stored_list)
	reset_rays.connect(CollectibleManager.set_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_new_checkpoint(pos : Vector3, amount : int):
	respawn_pos = pos
	saved_rays = amount
	emit_signal("checkpoint_updated")
	#print(respawn_pos)

func reset():
	#respawn_pos = initial_respawn_pos
	await get_tree().create_timer(.5).timeout
	respawn_pos = Vector3(0.0, 3.956, -1.4)

func respawn_player():
	emit_signal("reset_rays", CollectibleManager.CollectibleType.COIN, saved_rays)
