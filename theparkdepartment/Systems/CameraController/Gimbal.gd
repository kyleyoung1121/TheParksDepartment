extends Node3D

@onready var camera = $InnerGimbal/Camera3D
@onready var inner_gimbal = $InnerGimbal

@export var max_zoom = 250.0
@export var min_zoom = 5
@export var zoom_speed = 10
var zoom: float = 150.0

@export var speed = 0.1
@export var drag_speed = 0.0005
@export var acceleration = 0.1
@export var mouse_sensitivity = 0.0005

var move = Vector3()

func _input(event):
	# Camera rotation input
	if Input.is_action_pressed("camera_rotate") and event is InputEventMouseMotion:
		if event.relative.x != 0:
			rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var y_rotation = clamp(-event.relative.y, -30, 30)
			inner_gimbal.rotate_object_local(Vector3.RIGHT, y_rotation * mouse_sensitivity)
	
	# Camera movement input
	if Input.is_action_pressed("camera_move") and event is InputEventMouseMotion:
		move.x -= event.relative.x * drag_speed
		move.z -= event.relative.y * drag_speed
	
	# Zoom input
	if event.is_action_pressed("camera_zoom_in"):
		zoom -= zoom_speed
	elif event.is_action_pressed("camera_zoom_out"):
		zoom += zoom_speed

	zoom = clamp(zoom, min_zoom, max_zoom)

func _ready():
	# Set camera properties
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.position = Vector3(0, 0, 0)
	camera.rotation = Vector3(0, 0, 0)

	# Set inner gimbal properties
	inner_gimbal.position = Vector3(0, 0, 0)
	inner_gimbal.rotation = Vector3(-0.536697, 0, 0)

	# Set the gimbal's rotation
	rotation = Vector3(0, -0.7853982, 0)

func _process(delta):
	# Smoothly adjust zoom
	if camera.projection == Camera3D.PROJECTION_ORTHOGONAL:
		camera.size = lerp(camera.size, zoom, zoom_speed * delta)

	# Clamp rotation to avoid excessive tilting
	inner_gimbal.rotation.x = clamp(inner_gimbal.rotation.x, -1.1, 0.3)

	move_camera(delta)

func move_camera(delta):
	# Camera movement in the X and Z directions
	if Input.is_action_pressed("camera_move_forward"):
		move.z = lerp(move.z, -speed, acceleration)
	elif Input.is_action_pressed("camera_move_backward"):
		move.z = lerp(move.z, speed, acceleration)
	else:
		move.z = lerp(move.z, 0.0, acceleration)
	
	if Input.is_action_pressed("camera_move_left"):
		move.x = lerp(move.x, -speed, acceleration)
	elif Input.is_action_pressed("camera_move_right"):
		move.x = lerp(move.x, speed, acceleration)
	else:
		move.x = lerp(move.x, 0.0, acceleration)
	
	# Apply movement to camera with rotation
	position += move.rotated(Vector3.UP, self.rotation.y) * zoom
