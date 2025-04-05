extends Node

@onready var current_animal: Node3D = null

var animal_scenes = {
	"AmericanGoldfinch": preload("res://Entities/Animals/AmericanGoldfinch/AmericanGoldfinch.tscn"),
	"CoopersHawk": preload("res://Entities/Animals/CoopersHawk/CoopersHawk.tscn"),
	"Coyote": preload("res://Entities/Animals/Coyote/Coyote.tscn"),
	"Deer": preload("res://Entities/Animals/Deer/Deer.tscn"),
	"EasternWolf": preload("res://Entities/Animals/EasternWolf/EasternWolf.tscn"),
	"Rabbit": preload("res://Entities/Animals/Rabbit/Rabbit.tscn"),
}

var placement_in_progress = false
var follow_mouse = false
var selected_animal_type
var selected_animal_scene: PackedScene = null

var in_game_menu


func _ready():
	var parent = get_parent()
	in_game_menu = parent.get_node("InGameMenu")


func _process(delta):
	if follow_mouse:
		var mouse_pos = get_mouse_world_position()

		# Handle preview movement
		if is_instance_valid(current_animal):
			current_animal.global_transform.origin = mouse_pos

		# Handle placement request
		if Input.is_action_just_pressed("place_structure"):
			in_game_menu.placement_requested("Animal", selected_animal_type)
			follow_mouse = false


# TODO: Do not add the actual animal to the scene. 
#       - It can be consumed while in preview mode
#       - Animal will begin walking after left click, before confirm button
func start_placing(animal_type: String):
	if placement_in_progress:
		return

	print("Object Placement: start_placing() called!")
	placement_in_progress = true
	follow_mouse = true
	selected_animal_type = animal_type

	if current_animal:
		current_animal.queue_free()
		current_animal = null

	if animal_scenes.has(animal_type):
		selected_animal_scene = animal_scenes[animal_type]
	else:
		selected_animal_scene = null
	
	if selected_animal_scene:
		current_animal = selected_animal_scene.instantiate()
		add_child(current_animal)
		for mesh in current_animal.get_children():
			if mesh is MeshInstance3D:
				var mat = mesh.get_surface_override_material(0)
				if mat is StandardMaterial3D:
					mat.albedo_color.a = 0.5


func confirm_placement():
	print("placement: going to confirm animal")
	
	if current_animal:
		print("placement: confirmed animal")
		var final_building = selected_animal_scene.instantiate()
		final_building.global_transform.origin = current_animal.global_transform.origin
		get_parent().add_child(final_building)
		current_animal.queue_free()
		current_animal = null
	
	placement_in_progress = false


func cancel_placement():
	if current_animal:
		current_animal.queue_free()
		current_animal = null

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
