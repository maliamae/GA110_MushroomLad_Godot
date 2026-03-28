extends Area3D

var pos : Vector3
var rays : int

signal checkpoint_reached(pos, rays)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_reached.connect(CheckpointManager.set_new_checkpoint)
	pos = Vector3(global_position.x, global_position.y + 2, global_position.z)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if body.name == "Player":
		#get current number of rays collected
		rays = CollectibleManager.get_amount(CollectibleManager.CollectibleType.COIN)
		#send signal to checkpoint manager with this position
		emit_signal("checkpoint_reached", pos, rays)
