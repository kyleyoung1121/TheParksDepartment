extends Node3D

@export var base_speed: float = 3.0
var speed: float
var path: Path3D
var distance: float = 0.0
var offset: Vector3 = Vector3.ZERO

var animation_player: AnimationPlayer

func _ready():
	animation_player = $Guest/AnimationPlayer
	animation_player.play("walking")
	animation_player.get_animation("walking").loop = true

	# Randomize Guest.blend scale slightly
	var guest_mesh = $Guest
	guest_mesh.scale *= randf_range(0.8, 1.1)
	guest_mesh.scale.y *= randf_range(0.8, 1.2)

	# Randomize speed slightly (±25%)
	speed = base_speed * randf_range(0.75, 1.25)

	# Apply a small random lateral offset (XZ plane only)
	offset = Vector3(
		randf_range(-2.0, 2.0),  # X
		0,
		randf_range(-2.0, 2.0)   # Z
	)

func _process(delta):
	if not path:
		return

	var curve = path.curve
	distance += delta * speed

	if distance >= curve.get_baked_length():
		var guest_reward = 5
		guest_reward *= OhioEcosystemData.ecosystem_multiplier
		guest_reward = round(guest_reward)
		OhioEcosystemData.funds += guest_reward
		queue_free()
	else:
		var pos = curve.sample_baked(distance) + offset
		global_position = pos

		# Look ahead slightly to get direction
		var look_ahead_distance = 0.1
		var next_distance = min(distance + look_ahead_distance, curve.get_baked_length())
		var next_pos = curve.sample_baked(next_distance) + offset

		# Face the direction of movement
		look_at(next_pos, Vector3.UP)
