extends Area3D

#floating barrels that sink when player contacts them

var initial_pos: Vector3 
var max_height: float
var min_height: float
@export var move_distance = .5
var oscilate_t = 0.0
var reset_t = 0.0

@export var move_speed = 25
var is_under_player: bool = false
var reseting: bool = false

@onready var platform: Node3D = $".." #reference to parent node of barrel this script is attached to

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#save initial position and set max/min heights
	initial_pos = platform.global_position 
	max_height = initial_pos.y
	min_height = max_height - move_distance
	oscilate_t = randf_range(0.0, 1.0) #gives random variation of starting time in oscilation sequence


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_under_player && not reseting:
		#oscilate like normal object floating on water
		oscilate_height(delta)
	elif not is_under_player && reseting:
		#reset platform to original position
		reset_pos(delta)
	else:
		#player is on platform and platform is sinking
		platform.global_position -= Vector3.UP * (move_speed * 0.01) * delta
	
	#if platform exceeds depth of min height * 1.5, begin reseting to initial position
	if platform.global_position.y < (initial_pos.y - move_distance * 1.5): # && not reseting:
		reseting = true
		is_under_player = false

#moves platform up and down constantly
func oscilate_height(delta):
	platform.global_position = Vector3(initial_pos.x, lerpf(max_height, min_height, oscilate_t),initial_pos.z)
	oscilate_t += 0.01 * move_speed * delta
	
	#set reset time to 0 to ensure that when platform begins reseting it begins from it's expected height
	reset_t = 0.0
	
	#once target position is reached, values of the max/min height are swapped and the cycle continues
	if (oscilate_t > 1.0):
		var temp = max_height
		max_height = min_height
		min_height = temp
		oscilate_t = 0.0

#registers player coming into contact to begin sinking
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		is_under_player = true

#returns platform to last target position in oscilation cycle
func reset_pos(delta):
	#print("reseting")
	var current_y = initial_pos.y - move_distance * 1.5
	platform.global_position = Vector3(initial_pos.x, lerpf(current_y, max_height, reset_t),initial_pos.z)
	reset_t += 0.01 * move_speed * delta
	
	oscilate_t = 0.0
	
	#ends reseting cycle
	if (reset_t > 1.0):
		reseting = false
