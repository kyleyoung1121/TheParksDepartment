extends Node

signal RequestToPlace

@export var confirmation_window: ConfirmationDialog  # Drag your confirmation window here
@onready var current_building: Node3D = null

var follow_mouse = true

# Store available building scenes
var building_scenes = {
	#"Fence": preload("res://Props/Artificial/Fence/Fence.tscn"),
	"Log Cabin": preload("res://Props/Artificial/Log House/LogHouse.tscn"),
	"Watchtower": preload("res://Props/Artificial/Watchtower/Watchtower.tscn"),
	"Trees": preload("res://Props/Natural/Trees/TreeCluster.tscn"),
	#"Bathroom": preload(""),
}

var selected_building_scene: PackedScene = null


func _process(delta):
	if is_instance_valid(current_building) and follow_mouse:
		# Move the preview building to the mouse
		current_building.global_transform.origin = get_mouse_world_position()
		# Check if the user is placing the structure
		if Input.is_action_just_pressed("place_structure"):
			emit_signal("RequestToPlace")
			follow_mouse = false
	else:
		current_building = null


func start_placing(selected_object: String):
	print("Object Placement: start_placing() called!")
	follow_mouse = true
	
	# Remove any previous preview
	if current_building:
		current_building.queue_free()
		current_building = null
	
	# Set the appropriate packed scene
	if building_scenes.has(selected_object):
		selected_building_scene = building_scenes[selected_object]
	else:
		selected_building_scene = null

	if selected_building_scene:
		current_building = selected_building_scene.instantiate()
		add_child(current_building)
		
		# Set transparency (assumes MeshInstance3D with a StandardMaterial3D)
		for mesh in current_building.get_children():
			if mesh is MeshInstance3D:
				var mat = mesh.get_surface_override_material(0)
				if mat is StandardMaterial3D:
					mat.albedo_color.a = 0.5  # 50% transparency



func place_building():
	if current_building:
		emit_signal("RequestToPlace", current_building)


func confirm_placement():
	if current_building:
		# Permanently place the building
		var final_building = selected_building_scene.instantiate()
		final_building.global_transform.origin = current_building.global_transform.origin
		get_parent().add_child(final_building)

		# Remove preview
		current_building.queue_free()
		current_building = null


func cancel_placement():
	if current_building:
		current_building.queue_free()
		current_building = null


func get_mouse_world_position() -> Vector3:
	var space_state = get_viewport().get_world_3d().direct_space_state
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result.has("position"):
		return result["position"]
	return Vector3.ZERO
