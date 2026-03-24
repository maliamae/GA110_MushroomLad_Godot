extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 3.0
@export var acceleration := 5.0
@export var rotation_speed := 12.0
@export var jump_impulse := 6.0
@export var dash_impulse := 15.0
@export var is_climbing := false
@export var can_dash := true
@export var dash_duration := .5

var gravity := -20.0

var camera_input_direction := Vector2.ZERO

var last_movement_direction := Vector3.FORWARD
var raw_input: Vector2
var forward
var right
var move_direction
var target_angle


@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var character_model: Node3D = %"animal-caterpillar2"
@onready var animation_player: AnimationPlayer = $"animal-caterpillar2/AnimationPlayer"
@onready var climb_ray_cast: RayCast3D = $"animal-caterpillar2/RayCast3D"

#only rotates the camera when the mouse is clicked into the game
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	
	if is_camera_motion:
		camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	#rotate around the x-axis
	camera_pivot.rotation.x += camera_input_direction.y * delta
	#clamp the rotation
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 6.0, PI/3.0)
	#rotate around the y-axis
	camera_pivot.rotation.y -= camera_input_direction.x * delta
	
	#reset the input direction to zero
	camera_input_direction = Vector2.ZERO
	
	#handle which movement logic to follow (grounded movement or climbing movement)
	if is_climbing:
		move_climbing(delta)
	else:
		move_grounded(delta)
	
	
	#allow jumps only when on the floor
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
	
	#allows jump when climbing in direction opposite the wall the player is currently climbing
	var is_starting_jump_climb := Input.is_action_just_pressed("jump") and is_climbing
	if is_starting_jump_climb:
		velocity = character_model.basis.z * -50.0
	
	#allows dashing 
	var is_starting_dash := Input.is_action_just_pressed("dash") and can_dash
	if is_starting_dash:
		player_dash(delta)
	
	#move the character
	move_and_slide()
	
	#smooth out character direction while turning
	character_model.global_rotation.y = lerp_angle(
		character_model.rotation.y, 
		target_angle, 
		rotation_speed * delta
	)
	
	#play animations
	if is_starting_jump:
		#animation_player.play("jump")
		pass
	elif not is_on_floor() and velocity.y < 0:
		#animation_player.play("fall")
		pass
	elif is_on_floor():
		var ground_speed := velocity.length()
		if ground_speed > 0.0:
			animation_player.play("walk")
		else:
			animation_player.play("static")

func move_grounded(delta):
	#stores player inputs into a Vector2
	raw_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	#extracts forward and right direction vector in relation to the camera
	forward = camera_3d.global_basis.z
	right = camera_3d.global_basis.x
	
	#calculate the move direction
	move_direction = forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	#separate and extract vertical component of velocity
	var y_velocity := velocity.y
	velocity.y = 0.0
	
	#calculate player velocity
	velocity = velocity.move_toward(move_direction * move_speed, acceleration)# * delta)
	
	#apply gravity to character
	velocity.y = y_velocity + gravity * delta
	
	#store the last movement direction
	if move_direction.length() > 0.0:
		last_movement_direction = move_direction
	
	#turn toward the last movement direction
	target_angle = Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)

func move_climbing(delta):
	#stores player inputs into a Vector2
	raw_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	#moves player's forward facing direction towards the wall they are currently climbing
	if climb_ray_cast.is_colliding():
		var climb_direction = -climb_ray_cast.get_collision_normal()
		target_angle = Vector3.BACK.signed_angle_to(climb_direction, Vector3.UP)
	
	#forward handles up and down movement, right handles left and right movement
	forward = -character_model.basis.y
	right = -character_model.basis.x
	
	#calculate the move direction
	move_direction = right * raw_input.x + forward * raw_input.y
	move_direction = move_direction.normalized()
	
	#calculate player velocity
	velocity = velocity.move_toward(move_direction * move_speed/2, acceleration)# * delta)

#adds forward force to player for a duration of time 
func player_dash(delta):
	can_dash = false
	var t := 0.0
	
	while t < dash_duration:
		t += delta
		velocity += character_model.basis.z * lerpf(dash_impulse, 0.0, t/dash_duration)
		await Engine.get_main_loop().process_frame
	
	await get_tree().create_timer(.35).timeout
	can_dash = true
