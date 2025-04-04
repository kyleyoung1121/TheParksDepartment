extends Node3D

@export var speed: float = 3.0
var path: Path3D
var distance: float = 0.0

func _process(delta):
	if not path:
		return

	var curve = path.curve
	distance += delta * speed

	if distance >= curve.get_baked_length():
		OhioEcosystemData.funds += 5
		queue_free()
	else:
		var pos = curve.sample_baked(distance)
		global_position = pos

		# Look ahead slightly to get direction
		var look_ahead_distance = 0.1  # tweak if necessary
		var next_distance = min(distance + look_ahead_distance, curve.get_baked_length())
		var next_pos = curve.sample_baked(next_distance)

		# Face the direction of movement
		look_at(next_pos, Vector3.UP)
