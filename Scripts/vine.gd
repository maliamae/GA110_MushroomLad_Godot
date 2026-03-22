extends Node3D

@onready var player: CharacterBody3D = $"../../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player.is_climbing = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player.is_climbing = false
