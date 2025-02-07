extends MeshInstance3D


# Plant variables; export the ones that we want to tweak in the editor
@export var species: String
@export var self_scene_path: String

@onready var cluster_area = $ClusterDetection
@onready var cluster_collision = $ClusterDetection/ClusterDetectionCollision

var plant_name: String
var max_age: int
var age: int
var nutrition: int
var reproduction_cooldown: int
var reproduction_timer: int
var cluster_range: int
var max_cluster_neighbors: int
var plant_position: Vector2


func _ready():
	# Fetch settings for this particular plant
	reproduction_cooldown = OhioEcosystemData.plants_species_data[species]["reproduction_cooldown"]
	max_age = OhioEcosystemData.plants_species_data[species]["max_age"]
	nutrition = OhioEcosystemData.plants_species_data[species]["nutrition"]
	cluster_range = OhioEcosystemData.plants_species_data[species]["cluster_range"]
	max_cluster_neighbors = OhioEcosystemData.plants_species_data[species]["max_cluster_neighbors"]
	
	age = get_random_portion(max_age, "minority")
	reproduction_timer = get_random_portion(reproduction_cooldown, "majority")
	cluster_collision.shape.height = cluster_range
	cluster_collision.shape.radius = cluster_range
	


func get_random_portion(value, setting):
	var rough_forth = int(value/4)
	if rough_forth == 0:
		rough_forth = 1
	
	if setting == "majority":
		# Return somewhere between 100% and 75% of the original value
		return value - (randi() % rough_forth)
	else:
		# Return somewhere between 0% and 25%
		return (randi() % rough_forth)


func is_old() -> bool:
	return age >= max_age


func consumed():
	OhioEcosystemData.plants_species_data[species]["count"] -= 1
	queue_free()


func reproduce(count):
	# Get the parent scene so we can add the new instance to it
	var parent = get_parent()
	assert(not parent == null)
	
	# Check that this species hasn't hit its limit
	var population_limit = OhioEcosystemData.plants_species_data[species]["population_limit"]
	if OhioEcosystemData.plants_species_data[species]["count"] >= population_limit:
		return
	
	# Create a new instance of the current scene
	var new_plant = load(self_scene_path).instantiate()

	# Set position near the original plant
	new_plant.position = position + Vector3(randf_range(-8, 8), 0, randf_range(-8, 8))

	# Set a name based on what number plant this is
	new_plant.plant_name = species.to_lower() + "_" + str(OhioEcosystemData.plants_species_data[species]["count"])

	# Add the new instance to the scene
	parent.add_child(new_plant)
	#print("New plant has been born: " + plant_name)
	OhioEcosystemData.plants_species_data[species]["count"] += 1



func update():
	age += 1
	reproduction_timer -= 1
	
	# If the plant needs removed, remove it!
	if is_old():
		#print(plant_name, " died of starvation at ", position)
		consumed()
	
	# TODO: Plant reproduction should act differently right? Like based on available space?
	# Reproduce if conditions are right
	if reproduction_timer <= 0:
		
		var all_neighbors = cluster_area.get_overlapping_areas()
		var total_plant_neighbors = 0
		for neighbor in all_neighbors:
			if neighbor.is_in_group("plants_area"):
				total_plant_neighbors += 1
		
		if total_plant_neighbors <= max_cluster_neighbors:
			reproduction_timer = reproduction_cooldown
			reproduce(OhioEcosystemData.plants_species_data[species]["count"])


# Position the entity based on a 2d grid
# Note: we set position.z because in 3d, y refers to up/down
func set_grid_position(grid_position: Vector2):
	position.x = grid_position.x * OhioEcosystemData.grid_scale
	position.x += randf_range(-8, 8)
	position.z = grid_position.y * OhioEcosystemData.grid_scale
	position.z += randf_range(-8, 8)
