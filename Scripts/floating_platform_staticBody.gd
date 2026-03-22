extends StaticBody3D

var initial_pos: Vector3 
var max_height: float
var min_height: float
@export var move_distance = .5
var oscilate_t = 0.0

@export var move_speed = 25
var is_under_player: bool = false
var reseting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = global_position
	max_height = initial_pos.y
	min_height = max_height - move_distance
	oscilate_t = randf_range(0.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	oscilate_height(delta)


func oscilate_height(delta):
	global_position = Vector3(initial_pos.x, lerpf(max_height, min_height, oscilate_t),initial_pos.z)
	oscilate_t += 0.01 * move_speed * delta
	
	if (oscilate_t > 1.0):
		var temp = max_height
		max_height = min_height
		min_height = temp
		oscilate_t = 0.0
