extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 10.0
var gravity := -30.0

var camera_input_direction := Vector2.ZERO

var last_movement_direction := Vector3.FORWARD

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var character_model: Node3D = %"animal-caterpillar2"
@onready var animation_player: AnimationPlayer = $"animal-caterpillar2/AnimationPlayer"

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
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var forward := camera_3d.global_basis.z
	var right := camera_3d.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	
	velocity.y = y_velocity + gravity * delta
	
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
	
	move_and_slide()
	
	if move_direction.length() > 0.0:
		last_movement_direction = move_direction
	
	var target_angle := Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
	character_model.global_rotation.y = target_angle
	
	character_model.global_rotation.y = lerp_angle(
		character_model.rotation.y, 
		target_angle, 
		rotation_speed * delta
	)
	
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
	
	
	
	
	
