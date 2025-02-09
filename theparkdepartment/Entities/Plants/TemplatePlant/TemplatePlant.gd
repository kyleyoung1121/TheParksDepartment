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
var extra_resilience: float

var regrowing = false
var half_tile = OhioEcosystemData.grid_scale * 0.5
var grid_bounds_min = -0.5 * OhioEcosystemData.grid_scale
var grid_bounds_max = (OhioEcosystemData.grid_scale) * (OhioEcosystemData.grid_size - 0.5)


func _ready():
	# Fetch settings for this particular plant
	reproduction_cooldown = OhioEcosystemData.plants_species_data[species]["reproduction_cooldown"]
	max_age = OhioEcosystemData.plants_species_data[species]["max_age"]
	nutrition = OhioEcosystemData.plants_species_data[species]["nutrition"]
	cluster_range = OhioEcosystemData.plants_species_data[species]["cluster_range"]
	max_cluster_neighbors = OhioEcosystemData.plants_species_data[species]["max_cluster_neighbors"]
	extra_resilience = OhioEcosystemData.plants_species_data[species]["extra_resilience"]
	
	age = get_random_portion(max_age, 0, 0.25)
	reproduction_timer = get_random_portion(reproduction_cooldown, 0.75, 1)
	cluster_collision.shape.height = cluster_range
	cluster_collision.shape.radius = cluster_range


func update():
	# Don't do anything else if in the growing stage
	if regrowing:
		return
	
	age += 1
	reproduction_timer -= 1
	
	# If the plant needs removed, remove it!
	if is_old():
		consumed()
		#print(plant_name, " died of starvation at ", position)
	
	# Reproduce if conditions are right
	if reproduction_timer <= 0:
		
		var all_neighbors = cluster_area.get_overlapping_areas()
		var total_plant_neighbors = 0
		for neighbor in all_neighbors:
			# TODO: This doesn't work. Verify that we are getting the correct part of the plant nodes
			if neighbor.is_in_group("plants_area"):
				total_plant_neighbors += 1
		#print("total_plant_neighbors: ", total_plant_neighbors)
		if total_plant_neighbors <= max_cluster_neighbors:
			reproduction_timer = reproduction_cooldown
			reproduce(OhioEcosystemData.plants_species_data[species]["count"])


func consumed():
	# Plant cannot be consumed while regrowing
	if regrowing:
		return
	
	# Chance to resist being deleted
	if randf() > extra_resilience:
		
		# Another chance to enter regrowing mode instead of being fully deleted
		if randf() > extra_resilience:
			OhioEcosystemData.plants_species_data[species]["count"] -= 1
			queue_free()
		else:
			# Plant should disappear as if eaten for some time, then it should come back
			regrowing = true
			visible = false
			age = get_random_portion(max_age, 0, 0.25)
			reproduction_timer = get_random_portion(reproduction_cooldown, 0, 0.25)
			remove_from_group("plants")
			
			# Wait a random amount of time
			await get_tree().create_timer(randf_range(15, 60)).timeout
			
			# The plant should now come back
			visible = true
			regrowing = false
			add_to_group("plants")


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
	var offset = Vector3()
	offset.x = randf_range(-half_tile, half_tile)
	offset.z = randf_range(-half_tile, half_tile)
	new_plant.clamp_position(position + offset)

	# Set a name based on what number plant this is
	new_plant.plant_name = species.to_lower() + "_" + str(OhioEcosystemData.plants_species_data[species]["count"])

	# Add the new instance to the scene
	parent.add_child(new_plant)
	#print("New plant has been born: " + plant_name)
	OhioEcosystemData.plants_species_data[species]["count"] += 1


func is_old() -> bool:
	return age >= max_age


# Position the entity based on a 2d grid
# Note: we set position.z because in 3d, y refers to up/down
func set_grid_position(grid_x, grid_y):
	position.x = grid_x * OhioEcosystemData.grid_scale
	position.z = grid_y * OhioEcosystemData.grid_scale
	position.x += randf_range(-half_tile, half_tile)
	position.z += randf_range(-half_tile, half_tile)
	clamp_position(position)


func clamp_position(target_position):
	var clamped_position = target_position
	clamped_position.x = clampf(clamped_position.x, grid_bounds_min, grid_bounds_max)
	clamped_position.z = clampf(clamped_position.z, grid_bounds_min, grid_bounds_max)
	position = clamped_position
	return clamped_position


func get_random_portion(value, low, high):
	var random_portion = randf_range(low, high)
	return value * random_portion
