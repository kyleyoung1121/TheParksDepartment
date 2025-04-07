extends Node

@onready var current_preview: Node3D = null

var animal_scenes = {
	"AmericanGoldfinch": preload("res://Entities/Animals/AmericanGoldfinch/AmericanGoldfinch.tscn"),
	"CoopersHawk": preload("res://Entities/Animals/CoopersHawk/CoopersHawk.tscn"),
	"Coyote": preload("res://Entities/Animals/Coyote/Coyote.tscn"),
	"Deer": preload("res://Entities/Animals/Deer/Deer.tscn"),
	"EasternWolf": preload("res://Entities/Animals/EasternWolf/EasternWolf.tscn"),
	"Rabbit": preload("res://Entities/Animals/Rabbit/Rabbit.tscn"),
	"Squirrel": preload("res://Entities/Animals/Squirrel/Squirrel.tscn"),
}

var animal_crate_scene = preload("res://Props/Artificial/AnimalCrate/AnimalCrate.blend")

var placement_in_progress = false
var follow_mouse = false
var selected_animal_type
var selected_animal_scene = null

var in_game_menu


func _ready():
	in_game_menu = get_parent().get_node("InGameMenu")


func _process(delta):
	if follow_mouse:
		var mouse_pos = get_mouse_world_position()

		if is_instance_valid(current_preview):
			current_preview.global_transform.origin = mouse_pos

		if Input.is_action_just_pressed("place_structure"):
			in_game_menu.placement_requested("Animal", selected_animal_type)
			follow_mouse = false


func start_placing(animal_type: String):
	if placement_in_progress:
		return

	if current_preview:
		current_preview.queue_free()
		current_preview = null

	if not animal_scenes.has(animal_type):
		selected_animal_scene = null
	
	
	# Randomly assign gender
	var gender = "Male" if randi() % 2 == 0 else "Female"
	
	if gender == "Male":
		selected_animal_scene = OhioEcosystemData.animals_species_data[animal_type]["male_mesh_path"]
	else:
		selected_animal_scene = OhioEcosystemData.animals_species_data[animal_type]["female_mesh_path"]
	
	if selected_animal_scene and animal_crate_scene:
		selected_animal_type = animal_type
		placement_in_progress = true
		follow_mouse = true
		current_preview = animal_crate_scene.instantiate()
		add_child(current_preview)


func confirm_placement():
	
	if current_preview:
		# Get the choosen animal and add it to the parent scene
		var final_animal = load(selected_animal_scene).instantiate()
		final_animal.global_transform.origin = current_preview.global_transform.origin
		get_parent().add_child(final_animal)
		# Decrease resources and increase animal's population count
		OhioEcosystemData.release_count -= 1
		if OhioEcosystemData.release_count < 0:
			OhioEcosystemData.release_count = 0
		if selected_animal_type in OhioEcosystemData.animals_species_data:
			OhioEcosystemData.animals_species_data[selected_animal_type]["count"] += 1
		# Remove the animal crate preview
		current_preview.queue_free()
		current_preview = null
	
	placement_in_progress = false


func cancel_placement():
	if current_preview:
		current_preview.queue_free()
		current_preview = null

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
