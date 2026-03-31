extends Area3D

@export var type: CollectibleManager.CollectibleType
@export var amount: int = 1
var collectible : Node3D

const ROT_SPEED = 2
var initial_pos
var max_height
var min_height
@export var move_speed = 50
@export var move_distance = .25
var oscilate_t = 0.0

signal collected(type, amount)
signal store_node(collectible)

func _ready():
	#connect signals to collectible manager functions
	collected.connect(CollectibleManager.add_collectible)
	store_node.connect(CollectibleManager.store_collectible)
	
	#oscilating info
	initial_pos = global_position
	max_height = global_position.y
	min_height = global_position.y - move_distance
	oscilate_t = randf_range(0.0, 1.0) #gives random variation of starting time in oscilation sequence
	
	#variable used to store node in list
	collectible = self

func _physics_process(delta: float) -> void:
	#collectible idle movement
	rotate_y(deg_to_rad(ROT_SPEED))
	oscilate_height(delta)

func _on_body_entered(body):
	#when player collides with collectible and the collectible is visible, object is hidden and signals are sent
	if body.name == "Player" && visible:
		emit_signal("collected", type, amount) #passes info to manager about amount to add
		emit_signal("store_node", collectible) #stores node in list of collectibles collected since last checkpoint
		hide() #hides not destroys in case player dies before reaching next checkpoint, in case checkpoint needs to be respawned


#moves collectible up and down constantly
func oscilate_height(delta):
	global_position = Vector3(initial_pos.x, lerpf(max_height, min_height, oscilate_t),initial_pos.z)
	oscilate_t += 0.01 * move_speed * delta
	
	#once target position is reached, values of the max/min height are swapped and the cycle continues
	if (oscilate_t > 1.0):
		var temp = max_height
		max_height = min_height
		min_height = temp
		oscilate_t = 0.0
