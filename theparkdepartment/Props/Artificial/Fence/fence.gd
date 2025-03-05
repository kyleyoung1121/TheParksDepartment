extends Node3D

# A list of edges that make up the fence, each defined by two Vector3 points.
var edges = []

# The mesh for the fence (load the imported asset)
var fence_scene : PackedScene = preload("res://Props/Artificial/Fence/Singular-Fence.blend")  # Path to your .blend file

# Scale factor to adjust the size of the fence segment
var scale_factor = Vector3(1, 1, 1)  # You can tweak this to make the fence larger or smaller

# Helper function to create a visual fence segment (using the imported mesh from the .blend file)
func create_fence_segment(start_pos: Vector3, end_pos: Vector3) -> Node3D:
	var segment_container = Node3D.new()  # Create a container node for the segments

	# Calculate the distance between the two points
	var distance = start_pos.distance_to(end_pos)
	
	# Determine the number of segments needed based on the distance and the original segment length
	var segment_length = 5.0  # Assuming the original segment length is 1 unit
	var num_segments = ceil(distance / segment_length)
	
	# Calculate the direction vector and step size
	var direction = (end_pos - start_pos).normalized()
	var step = direction * segment_length
	
	# Place the segments along the edge
	for i in range(num_segments):
		var segment = fence_scene.instantiate()  # Create an instance of the fence scene
		segment.scale = scale_factor  # Adjust the scale of the fence segment

		# Calculate the position for each segment
		var segment_position = start_pos + step * i  # Position each segment along the edge
		segment.transform.origin = segment_position  # Set the segment's position

		if abs(direction.x) > abs(direction.z): # If horizontal fence, rotate the segment to align with the edge
			segment.rotation_degrees = Vector3(0, 0, 0)  # No rotation needed for vertical fences
		elif abs(direction.z) > abs(direction.x): # If vertical fence, rotate the segment to align with the edge
			segment.rotation_degrees = Vector3(0, 90, 0)  # Rotate the segment 90 degrees around the Y-axis
		else: # If diagonal fence, rotate the segment to align with the edge
			# Compute the perpendicular direction to the line (for rotation)
			var _perpendicular_direction = direction.cross(Vector3(0, 1, 0))  # Perpendicular to the Y-axis (upward)

			# Rotate the segment so that it is aligned perpendicular to the line
			var rotation_angle = direction.angle_to(Vector3.FORWARD)  # Angle between the line and the forward direction
			segment.rotation_degrees = Vector3(0, rotation_angle * 180 / PI, 0)  # Convert radians to degrees

		segment_container.add_child(segment)  # Add the segment to the container


	return segment_container



# Replace the post creation with segment creation
func _ready():
	# Visualize the fence by drawing each edge
	for i in range(0, edges.size(), 2):
		var start_pos = edges[i]
		var end_pos = edges[i + 1]
		
		var segment = create_fence_segment(start_pos, end_pos)
		add_child(segment)
