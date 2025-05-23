extends Node3D

@onready var camera_target = $CameraTarget
@onready var spring_arm = $CameraTarget/SpringArm3D
@onready var camera = $CameraTarget/SpringArm3D/Camera3D

# Zoom settings
@export var max_zoom = 50.0
@export var min_zoom = 15.0
@export var zoom_speed = 5.0
var zoom: float = 30.0

# Panning settings
@export var speed = 2.0
@export var drag_speed = 0.09
@export var acceleration = 0.1
@export var mouse_sensitivity = 0.001
var move = Vector3()
var drag_velocity = Vector3.ZERO

# Orbiting rotation settings
@export var yaw_sensitivity = 0.001
@export var pitch_sensitivity = 0.001
@export var pitch_min = 8
@export var pitch_max = 90
var yaw = float()
var pitch = deg_to_rad(50.0)

var block_camera_movement = false
var last_mouse_position = Vector2.ZERO

func _input(event):
	if block_camera_movement:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	
	# Check if the mouse is hovering over UI elements before capturing input
	
	# Camera rotation input (orbiting system)
	if Input.is_action_pressed("camera_rotate") and event is InputEventMouseMotion and not block_camera_movement:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			last_mouse_position = event.position  # Save mouse position before capturing
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

	# Camera panning input (drag feature)
	if Input.is_action_pressed("camera_move") and event is InputEventMouseMotion:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			last_mouse_position = event.position  # Save mouse position before capturing
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		var forward = Vector3(-sin(camera_target.rotation.y), 0, -cos(camera_target.rotation.y))
		var right = Vector3(cos(camera_target.rotation.y), 0, -sin(camera_target.rotation.y))
		drag_velocity -= forward * event.relative.y * drag_speed * -1
		drag_velocity -= right * event.relative.x * drag_speed
	
	# Release mouse when user stops interacting
	if event is InputEventMouseButton and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if not (Input.is_action_pressed("camera_rotate") or Input.is_action_pressed("camera_move")):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.warp_mouse(last_mouse_position)  # Restore mouse to original position
	
	# Zoom input
	if event.is_action_pressed("camera_zoom_in"):
		zoom -= zoom_speed * (zoom / max_zoom)
	elif event.is_action_pressed("camera_zoom_out"):
		zoom += zoom_speed * (zoom / max_zoom)

	zoom = clamp(zoom, min_zoom, max_zoom)


func _ready():
	# Initialize camera zoom and position
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta):
	# Smoothly adjust zoom
	spring_arm.position.z = lerp(spring_arm.position.z, -zoom + 15, delta * 10)

	# Smoothly move the camera target (for panning)
	move_camera(delta)

	# Clamp pitch to limit looking too far up or down
	pitch = clamp(pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))


func _physics_process(delta):
	# Smoothly apply yaw and pitch rotation
	camera_target.rotation.y = lerp_angle(camera_target.rotation.y, yaw, delta * 10)
	camera_target.rotation.x = lerp(camera_target.rotation.x, pitch, delta * 10)
	
	# Stop drag velocity when the middle button is released
	if not Input.is_action_pressed("camera_move"):
		drag_velocity = lerp(drag_velocity, Vector3.ZERO, 0.1)


func move_camera(delta):
	# Calculate forward and right vectors based on camera yaw rotation
	var forward = Vector3(-sin(camera_target.rotation.y), 0, -cos(camera_target.rotation.y))
	var right = Vector3(cos(camera_target.rotation.y), 0, -sin(camera_target.rotation.y))
	
	# Scale movement speed based on zoom level
	var zoom_scale = lerp(0.2, 1.0, (zoom - min_zoom) / (max_zoom - min_zoom)) # Scale speed between 20% and 100%

	# Update movement based on input
	if Input.is_action_pressed("camera_move_forward"):
		move = move.lerp(forward * -speed * zoom_scale, acceleration)
	elif Input.is_action_pressed("camera_move_backward"):
		move = move.lerp(forward * speed * zoom_scale, acceleration)
	else:
		move = move.lerp(Vector3.ZERO, acceleration)

	if Input.is_action_pressed("camera_move_left"):
		move = move.lerp(right * speed * zoom_scale, acceleration)
	elif Input.is_action_pressed("camera_move_right"):
		move = move.lerp(right * -speed * zoom_scale, acceleration)
	else:
		move = move.lerp(Vector3.ZERO, acceleration)

	# Apply movement to the camera target, ensuring the Y axis remains unchanged
	var new_position = camera_target.position + move + drag_velocity * delta
	new_position.y = camera_target.position.y
	camera_target.position = new_position
	
	# Clamp X and Z to keep camera in bounds
	var half_tile = OhioEcosystemData.grid_scale / 2
	var grid_minus_half_tile = (OhioEcosystemData.grid_size * OhioEcosystemData.grid_scale) - half_tile
	
	var cam_x = camera_target.global_position.x
	var cam_z = camera_target.global_position.z
	
	if cam_x < -half_tile:
		camera_target.global_position.x = lerp(cam_x, -half_tile + 1.0, 0.1)
	elif cam_x > grid_minus_half_tile:
		camera_target.global_position.x = lerp(cam_x, grid_minus_half_tile + 1.0, 0.1)
		
	if cam_z < -half_tile:
		camera_target.global_position.z = lerp(cam_z, -half_tile + 1.0, 0.1)
	elif cam_z > grid_minus_half_tile:
		camera_target.global_position.z = lerp(cam_z, grid_minus_half_tile + 1.0, 0.1)
