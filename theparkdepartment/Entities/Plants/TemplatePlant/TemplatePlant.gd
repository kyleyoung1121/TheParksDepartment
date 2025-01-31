extends CharacterBody3D


# Plant variables; export the ones that we want to tweak in the editor
@export var plant_name: String
@export var species: String
@export var max_age: int
@export var gender: String
@export var reproduction_cooldown: int
@export var nutrition: int
# TODO: Work out how to handle reproduction. Do we just spawn another copy of this scene?
@export var self_scene = null

var age: int
var plant_position: Vector2
var reproduction_timer: int


func _ready():
	if gender == null:
		gender = "Male" if randi() % 2 == 0 else "Female"


func is_old() -> bool:
	return age >= max_age


func consumed():
	queue_free()


func reproduce(count: int):
	var baby_organism = self_scene
	baby_organism.init(position, species.to_lower() + "_" + str(count))
	print("Baby ", species, " created with name: ", baby_organism.name)
	return baby_organism


func update():
	age += 1
	reproduction_timer -= 1
	
	# If the plant needs removed, remove it!
	if is_old():
		print(name, " died of starvation at ", position)
		consumed()
		
	# Reproduce if conditions are right
	elif gender == "Female" and reproduction_timer <= 0:
		for plant in get_tree().get_nodes_in_group("plants"):
			if plant.species == species and plant.position == position and plant.gender != gender:
				print(name, " and ", plant.name, " reproducing at ", position)
				reproduction_timer = reproduction_cooldown
				var new_plant = reproduce(OhioEcosystemData.plant_species_data[species]["count"])
				OhioEcosystemData.plant_species_data[species]["count"] += 1
				# TODO: add the new plant to the scene


# Position the entity based on a 2d grid
# Note: we set position.z because in 3d, y refers to up/down
func set_grid_position(grid_position: Vector2):
	position.x = grid_position.x * OhioEcosystemData.grid_scale
	position.z = grid_position.y * OhioEcosystemData.grid_scale
