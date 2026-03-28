extends Area3D

const ROT_SPEED = 2
var initial_pos
var max_height
var min_height
@export var move_speed = 25
@export var move_distance = .25
var oscilate_t = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = global_position
	max_height = global_position.y
	min_height = global_position.y - move_distance
	oscilate_t = randf_range(0.0, 1.0) #gives random variation of starting time in oscilation sequence


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))
	oscilate_height(delta)
	
	#if has_overlapping_bodies():
		#queue_free()

func _on_body_entered(body: Node3D) -> void:
	queue_free()

#moves platform up and down constantly
func oscilate_height(delta):
	global_position = Vector3(initial_pos.x, lerpf(max_height, min_height, oscilate_t),initial_pos.z)
	oscilate_t += 0.01 * move_speed * delta
	
	#once target position is reached, values of the max/min height are swapped and the cycle continues
	if (oscilate_t > 1.0):
		var temp = max_height
		max_height = min_height
		min_height = temp
		oscilate_t = 0.0
