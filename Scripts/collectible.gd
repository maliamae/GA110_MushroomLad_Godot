extends Area3D

@export var type: CollectibleManager.CollectibleType
@export var amount: int = 1

signal collected(type, amount)

func _ready():
	collected.connect(CollectibleManager.add_collectible)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("collected", type, amount)
		call_deferred("queue_free")
