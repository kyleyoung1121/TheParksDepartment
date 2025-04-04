extends Node

@export var confirmation_window: ConfirmationDialog  # Drag your confirmation window here
@onready var current_building: Node3D = null

var placement_in_progress = false
var follow_mouse = false
var selected_structure_type

var in_game_menu

var building_scenes = {
	"Log Cabin": preload("res://Props/Artificial/Log House/LogHouse.tscn"),
	"Watchtower": preload("res://Props/Artificial/Watchtower/Watchtower.tscn"),
	"Trees": preload("res://Props/Natural/Trees/TreeCluster.tscn"),
}

var selected_building_scene: PackedScene = null

# Fence-specific
var fence_points: Array[Vector3] = []
var fence_preview_meshes: Array[Node3D] = []
@export var fence_preview_scene: PackedScene = preload("res://Props/Artificial/Fence/FencePost.tscn")
var fence_generation


func _ready():
	var parent = get_parent()
	in_game_menu = parent.get_node("InGameMenu")
	fence_generation = parent.get_node("FenceGeneration")


func _process(delta):
	if follow_mouse:
		var mouse_pos = get_mouse_world_position()

		# Handle preview movement
		if selected_structure_type == "Fence":
			if fence_preview_meshes.size() > 0 and is_instance_valid(fence_preview_meshes[-1]):
				fence_preview_meshes[-1].global_transform.origin = mouse_pos
		elif is_instance_valid(current_building):
			current_building.global_transform.origin = mouse_pos

		# Handle placement request
		if Input.is_action_just_pressed("place_structure"):
			if selected_structure_type == "Fence":
				fence_points.append(mouse_pos)

				var new_preview = fence_preview_scene.instantiate()
				new_preview.global_transform.origin = mouse_pos
				add_child(new_preview)
				fence_preview_meshes.append(new_preview)

				if fence_points.size() == 2:
					follow_mouse = false
					in_game_menu.placement_requested("Fence")
			else:
				in_game_menu.placement_requested(selected_structure_type)
				follow_mouse = false


func start_placing(structure_type: String):
	if placement_in_progress:
		return

	print("Object Placement: start_placing() called!")
	placement_in_progress = true
	follow_mouse = true
	selected_structure_type = structure_type

	if current_building:
		current_building.queue_free()
		current_building = null

	for preview in fence_preview_meshes:
		if is_instance_valid(preview):
			preview.queue_free()
	fence_preview_meshes.clear()
	fence_points.clear()

	if building_scenes.has(structure_type):
		selected_building_scene = building_scenes[structure_type]
	else:
		selected_building_scene = null

	if selected_structure_type == "Fence":
		var mouse_pos = get_mouse_world_position()
		var new_preview = fence_preview_scene.instantiate()
		new_preview.global_transform.origin = mouse_pos
		add_child(new_preview)
		fence_preview_meshes.append(new_preview)
	else:
		if selected_building_scene:
			current_building = selected_building_scene.instantiate()
			add_child(current_building)
			for mesh in current_building.get_children():
				if mesh is MeshInstance3D:
					var mat = mesh.get_surface_override_material(0)
					if mat is StandardMaterial3D:
						mat.albedo_color.a = 0.5


func confirm_placement():
	print("placement: going to confirm building")
	if selected_structure_type == "Fence":
		if fence_points.size() == 2:
			# Create the fence visually
			add_child(fence_generation.create_fence_segment(fence_points[0], fence_points[1]))

			# Add the new fence to the global data
			OhioEcosystemData.fences.append([fence_points[0], fence_points[1]])
			print("New fence added to global data:", fence_points[0], "to", fence_points[1])

		# Clear the preview meshes
		for preview in fence_preview_meshes:
			if is_instance_valid(preview):
				preview.queue_free()
		fence_preview_meshes.clear()
		fence_points.clear()
	else:
		if current_building:
			print("placement: confirmed building")
			var final_building = selected_building_scene.instantiate()
			final_building.global_transform.origin = current_building.global_transform.origin
			get_parent().add_child(final_building)
			current_building.queue_free()
			current_building = null
	
	placement_in_progress = false


func cancel_placement():
	if current_building:
		current_building.queue_free()
		current_building = null

	for preview in fence_preview_meshes:
		if is_instance_valid(preview):
			preview.queue_free()
	fence_preview_meshes.clear()
	fence_points.clear()
	placement_in_progress = false


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


func create_transparent_material() -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.6, 0.9, 1.0, 0.5)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.flags_transparent = true
	mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS
	return mat
