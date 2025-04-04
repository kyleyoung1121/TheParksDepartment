extends Node

var fence_scene: PackedScene = preload("res://Props/Artificial/Fence/Singular-Fence.blend")

func _ready():
	# Generate fences at startup from the global data
	for edge in OhioEcosystemData.fences:
		generate_fence(edge[0], edge[1])

# Function to generate a fence between two points
func generate_fence(start_pos: Vector3, end_pos: Vector3):
	if not fence_scene:
		push_error("Fence scene not assigned!")
		return

	var segment_container = Node3D.new()  # Container to hold all fence segments
	add_child(segment_container)

	var distance = start_pos.distance_to(end_pos)
	var segment_length = 20.0  # Adjust this based on actual fence segment size
	var num_segments = ceil(distance / segment_length)
	var direction = (end_pos - start_pos).normalized()
	var step = direction * segment_length

	for i in range(num_segments):
		var segment_position = start_pos + step * i

		var segment = fence_scene.instantiate()
		segment.transform.origin = segment_position

		# Align the fence to match the edge direction
		segment.look_at(end_pos, Vector3.UP)

		segment_container.add_child(segment)
