extends Area3D

var pos : Vector3
var rays : int
var has_entered := false

signal checkpoint_reached(pos, rays)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_reached.connect(CheckpointManager.set_new_checkpoint)
	pos = Vector3(global_position.x, global_position.y + 2, global_position.z)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if body.name == "Player" && not has_entered:
		#get current number of rays collected
		rays = CollectibleManager.get_amount(CollectibleManager.CollectibleType.COIN)
		#turn bool to true so the checkpoint can't get set twice
		has_entered = true
		#send signal to checkpoint manager with this position
		emit_signal("checkpoint_reached", pos, rays)
