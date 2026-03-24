extends Area3D

var initial_pos: Vector3 
var max_height: float
var min_height: float
@export var move_distance = .5
var oscilate_t = 0.0
var reset_t = 0.0

@export var move_speed = 25
var is_under_player: bool = false
var reseting: bool = false

@onready var platform: Node3D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = platform.global_position
	max_height = initial_pos.y
	min_height = max_height - move_distance
	oscilate_t = randf_range(0.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_under_player && not reseting:
		oscilate_height(delta)
	elif not is_under_player && reseting:
		#reset platform to original position
		reset_pos(delta)
	else:
		#player is on platform and platform is sinking
		#print("sinking")
		platform.global_position -= Vector3.UP * (move_speed * 0.01) * delta
	
	if platform.global_position.y < (initial_pos.y - move_distance * 1.5) && not reseting:
		reseting = true
		is_under_player = false
		#print("start reseting")


func oscilate_height(delta):
	platform.global_position = Vector3(initial_pos.x, lerpf(max_height, min_height, oscilate_t),initial_pos.z)
	oscilate_t += 0.01 * move_speed * delta
	
	reset_t = 0.0
	
	if (oscilate_t > 1.0):
		var temp = max_height
		max_height = min_height
		min_height = temp
		oscilate_t = 0.0


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		is_under_player = true

func reset_pos(delta):
	#print("reseting")
	var current_y = initial_pos.y - move_distance * 1.5
	platform.global_position = Vector3(initial_pos.x, lerpf(current_y, max_height, reset_t),initial_pos.z)
	reset_t += 0.01 * move_speed * delta
	
	oscilate_t = 0.0
		
	if (reset_t > 1.0):
		reseting = false
