extends Node

# The mesh for the fence (load the imported asset)
var fence_scene : PackedScene = preload("res://Props/Artificial/Fence/FenceSegment.blend")

# Scale factor to adjust the size of the fence segment
var scale_factor = Vector3(1, 1, 1)  # You can tweak this to make the fence larger or smaller

# Helper function to create a visual fence segment (using the imported mesh from the .blend file)
func create_fence_segment(start_pos: Vector3, end_pos: Vector3) -> Node3D:
	var segment_container = Node3D.new()  # Create a container node for the segments

	# Calculate the distance between the two points
	var distance = start_pos.distance_to(end_pos)
	
	# Determine the number of segments needed based on the distance and the original segment length
	var segment_length = 2.1
	var num_segments = ceil(distance / segment_length)
	
	# Calculate the direction vector and step size
	var direction = (end_pos - start_pos).normalized()
	var step = direction * segment_length
	
	# Compute rotation for proper alignment
	var forward = Vector3.FORWARD
	var axis = forward.cross(direction).normalized()
	var angle = acos(forward.dot(direction))  # Angle between forward and direction
	var rotation_quat = Quaternion(axis, angle)  

	# Apply a 90-degree correction around the Y-axis
	var correction_quat = Quaternion(Vector3.UP, PI / 2)
	var final_rotation = correction_quat * rotation_quat  # Apply correction after computing direction rotation

	# Adjust the position of the first segment (half segment length offset)
	var first_segment_offset = direction * (segment_length / 2.0)
	var position = start_pos + first_segment_offset
	
	# Place the segments along the edge
	for i in range(num_segments):
		var segment = fence_scene.instantiate()  # Create an instance of the fence scene
		segment.scale = scale_factor  # Adjust the scale of the fence segment

		# Calculate the position for each segment
		var segment_position = position + step * i  # Position each segment along the edge
		segment.transform.origin = segment_position  # Set the segment's position

		# Apply corrected quaternion rotation
		segment.transform.basis = Basis(final_rotation)

		segment_container.add_child(segment)  # Add the segment to the container

	# Adjust the position of the last segment to make sure it's properly aligned
	var last_segment_position = start_pos + direction * (segment_length * num_segments - (segment_length / 2.0))
	segment_container.get_child(num_segments - 1).transform.origin = last_segment_position
	
	return segment_container

# Function to load fences from OhioEcosystemData.gd
func load_fences_from_data():
	# Access the global OhioEcosystemData script directly to get the fences array
	var fences = OhioEcosystemData.fences  # Access fences array directly from the global script

	# Visualize the fence by drawing each edge
	for i in range(fences.size()):
		var start_pos = fences[i][0]
		var end_pos = fences[i][1]
		
		var segment = create_fence_segment(start_pos, end_pos)
		add_child(segment)

# Ready function to load fences
func _ready():
	load_fences_from_data()
