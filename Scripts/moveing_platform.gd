extends AnimatableBody3D

@export var position_a := Vector3()
@export var position_b := Vector3()

@export var move_duration := 2.0
@export var pause_duration := 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move()

func move():
	var move_tween = create_tween()
	move_tween.tween_property(self, "position", position_b, move_duration).set_delay(pause_duration)
	move_tween.tween_property(self, "position", position_a, move_duration).set_delay(pause_duration)
	await get_tree().create_timer(2 * move_duration + 2*pause_duration).timeout
	move()
