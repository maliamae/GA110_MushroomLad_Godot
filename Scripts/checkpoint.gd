extends Area3D

var pos : Vector3
var rays : int
var has_entered := false

#signal containing checkpoint position and number of rays currently collected
signal checkpoint_reached(pos, rays)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect signal to function in manager
	checkpoint_reached.connect(CheckpointManager.set_new_checkpoint)
	#set variable to current position
	pos = Vector3(global_position.x, global_position.y + 2, global_position.z)

func _on_body_entered(body):
	#when player reaches checkpoint for the first time, data is passed through signal to checkpoint manager
	if body.name == "Player" && not has_entered:
		#get current number of rays collected
		rays = CollectibleManager.get_amount(CollectibleManager.CollectibleType.ORB)
		#turn bool to true so the checkpoint can't get set twice
		has_entered = true
		#send signal to checkpoint manager with this position
		emit_signal("checkpoint_reached", pos, rays)
