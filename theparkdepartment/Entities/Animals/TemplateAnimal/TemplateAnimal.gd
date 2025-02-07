extends CharacterBody3D


# Animal variables; export the ones that we want to tweak in the editor
@export var species: String
@export var speed = 5.0
@export var movement_random_variation: float
@export var eating_distance: float = 2.0
@export var self_scene_path: String

var animal_name: String
var age: int
var gender: String
var animal_position: Vector2
var max_hunger: int
var hunger: int
var diet_type: String
var nutrition: int
var prey_organisms: Array
var max_age: int
var max_social: int
var social: int
var social_group_size: int
var eye_sight: int
var movement_chance: float
var reproduction_cooldown: int
var reproduction_timer: int
var desired_position = Vector3()
var animation_action: String = "idle"

# TODO: Should we just set the original variable, or separate like this?
var adjusted_eye_sight: float
var adjusted_eating_distance: float
var reproduction_range: float
var social_range: float


func _ready():
	# Make sure species is set on this animal! (from the editor)
	assert(not species == null)
	
	# Fetch settings for this particular animal
	max_hunger = OhioEcosystemData.animals_species_data[species]["max_hunger"]
	reproduction_cooldown = OhioEcosystemData.animals_species_data[species]["reproduction_cooldown"]
	max_age = OhioEcosystemData.animals_species_data[species]["max_age"]
	eye_sight = OhioEcosystemData.animals_species_data[species]["eye_sight"]
	movement_chance = OhioEcosystemData.animals_species_data[species]["movement_chance"]
	nutrition = OhioEcosystemData.animals_species_data[species]["nutrition"]
	diet_type = OhioEcosystemData.animals_species_data[species]["diet_type"]
	prey_organisms = OhioEcosystemData.animals_species_data[species]["prey_organisms"]
	max_social = OhioEcosystemData.animals_species_data[species]["max_social"]
	social_group_size = OhioEcosystemData.animals_species_data[species]["social_group_size"]
	
	# Set initial conditions (slightly random)
	hunger = get_random_portion(max_hunger, "majority")
	reproduction_timer = get_random_portion(reproduction_cooldown, "majority") 
	age = 0 + get_random_portion(max_age, "minority")
	speed *= randf_range(0.8, 1.2)
	social = get_random_portion(max_social, "majority")
	
	# Randomly assign gender
	gender = "Male" if randi() % 2 == 0 else "Female"
	
	# TODO: Determine how distance works. Maybe 1 eye_sight = 1/4 grid?
	adjusted_eye_sight = eye_sight * OhioEcosystemData.grid_scale * 0.25
	adjusted_eating_distance = eating_distance * OhioEcosystemData.grid_scale * 0.25
	reproduction_range = adjusted_eating_distance
	social_range = adjusted_eye_sight / 4


func _physics_process(delta):
	# Determine what direction the animal wants to move in
	var direction = (desired_position - position).normalized()
	
	# Move in the x and z directions as needed (y is height, so ignore it for now)
	if direction and direction > Vector3(0.1,0.1,0.1):
		animation_action = "walking"
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# Set y rotation based on movement direction
		rotation.y = atan2(-direction.x, -direction.z)
	else:
		animation_action = "idle"
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# Apply the new velocity
	move_and_slide()


# Update where the animal is trying to walk (include some randomness)
func set_desired_position(input_position):
	desired_position = input_position
	var change_x = randf_range(-movement_random_variation, movement_random_variation)
	var change_y = randf_range(-movement_random_variation, movement_random_variation)
	var change_z = randf_range(-movement_random_variation, movement_random_variation)
	desired_position += Vector3(change_x, change_y, change_z)


# Figure out if the animal will move now
func decide_to_move():
	return randf() < movement_chance


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


func decrease_hunger(amount):
	hunger -= amount


func is_starved() -> bool:
	return hunger <= 0


func is_old() -> bool:
	return age >= max_age


func consumed():
	animation_action = "dying"
	# TODO: Add some delay to allow the animation to complete
	queue_free()


func reproduce():
	# Get the parent scene so we can add the new instance to it
	var parent = get_parent()
	assert(not parent == null)
	
	# Check that this species hasn't hit its limit
	var population_limit = OhioEcosystemData.animals_species_data[species]["population_limit"]
	if OhioEcosystemData.animals_species_data[species]["count"] >= population_limit:
		return
	
	# Create a new instance of the current scene
	var new_animal = load(self_scene_path).instantiate()
	new_animal.position = position + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	new_animal.animal_name = species.to_lower() + "_" + str(OhioEcosystemData.animals_species_data[species]["count"])
	new_animal.set_random_destination()
	
	# Add the new instance to the scene
	parent.add_child(new_animal)
	print("New " + species + " has been born: " + animal_name)
	OhioEcosystemData.animals_species_data[species]["count"] += 1


func decide_movement():

	# Define Weighting for each type of movement
	# This should make it so that we can easily adjust the likelihood of each type of movement
	var weight_food = 0.4
	var weight_social = 0.3

	# get all needs and find out their current percentage
	var hunger_percent = float(hunger) / float(max_hunger)
	var social_percent = float(social) / float(max_social)

	
	# if the percent is lower than the weight, then we will move towards that need

	# Find all nrarby entities, make a list of them, and score them based on their distance
	# Don't forget about predators and max social group size
	var all_entities = get_tree().get_nodes_in_group("animals") + get_tree().get_nodes_in_group("plants")

	# Find all predators that eat this animal, store their positions
	var predator_locations = []
	for entity in all_entities:
		if entity.species in prey_organisms:
			predator_locations.append(entity.position)

	# Find all entities that are in range
	var in_range = []
	for entity in all_entities:
		if position.distance_to(entity.position) <= adjusted_eye_sight:
			in_range.append(entity)

	# Score each entity based on their distance, if a predator is nearby (negative score), and if there are too many animals of the same species nearby (negative score)
	var scored_entities = []
	var score = 0
	for entity in in_range:
		if entity.species in prey_organisms:
			# make sure there arw no predators nearby, if there are, give a negative score
			for predator in predator_locations:
				if entity.position.distance_to(predator) <= adjusted_eye_sight:
					score = -100
			# make sure there are not too many of the same species nearby, if there are, give a negative score
			var same_species_count = 0
			for other_entity in in_range:
				if other_entity.species == entity.species:
					same_species_count += 1
			if same_species_count >= social_group_size:
				score = -100
			# give a score based on distance
			score = position.distance_to(entity.position)
			scored_entities.append({"entity": entity, "score": score})

	var temp
	# Sort the scored entities by their score
	for i in range(scored_entities.size()):
		for j in range(scored_entities.size() - 1):
			if scored_entities[j].score > scored_entities[j+1].score:
				temp = scored_entities[j]
				scored_entities[j] = scored_entities[j+1]
				scored_entities[j+1] = temp

	# If the animal is hungry, move towards food
	if hunger_percent < weight_food:
		for entity in scored_entities:
			entity = entity.entity
			if entity.species in prey_organisms:
				set_desired_position(entity.position)
				return
	# If the animal is lonely, move towards social
	elif social_percent < weight_social:
		for entity in scored_entities:
			entity = entity.entity
			if entity.species == species:
				set_desired_position(entity.position)
				return
	# If the animal is neither hungry nor lonely
	else:
		for entity in scored_entities:
			entity = entity.entity
			if entity.species == species and entity.gender == "Female" and entity.reproduction_timer <= 1 and entity.score > 0: # move towards mate
				set_desired_position(entity.position)
				return
			set_random_destination()


func move():
	if decide_to_move():
		decide_movement()


func update():
	move()
	age += 1
	reproduction_timer -= 1
	hunger -= 1
	social -= 1

	# Eat if possible/needed
	# If we are already full, don't eat anything nearby
	if hunger >= max_hunger:
		return false
	
	# Consider all plants and animals. If they are prey and it range, eat them
	if diet_type == "Herbivore" or diet_type == "Omnivore":
		var all_plants = get_tree().get_nodes_in_group("plants")
		all_plants.shuffle()
		for food_consideration in all_plants:
			# Only consider eating known prey_organisms
			if food_consideration.species in prey_organisms:
				# If the food is in range, eat it!
				if position.distance_to(food_consideration.position) <= adjusted_eating_distance:
					hunger = min(hunger + OhioEcosystemData.plants_species_data[food_consideration.species]["nutrition"], max_hunger)
					food_consideration.consumed()
					animation_action = "eating"
					#print(animal_name, " ate ", food_consideration.plant_name)
					return true
	
	if diet_type == "Carnivore" or diet_type == "Omnivore":
		var all_animals = get_tree().get_nodes_in_group("animals")
		all_animals.shuffle()
		for food_consideration in all_animals:
			# Only consider eating known prey_organisms
			if food_consideration.species in prey_organisms:
				# If the food is in range, eat it!
				if position.distance_to(food_consideration.position) <= adjusted_eating_distance:
					hunger = min(hunger + OhioEcosystemData.animals_species_data[food_consideration.species]["nutrition"], max_hunger)
					food_consideration.consumed()
					animation_action = "eating"
					#print(animal_name, " ate ", food_consideration.animal_name)
					return true

	# For every entity of same species in range, increase social
	var all_entities = get_tree().get_nodes_in_group("animals")
	for entity in all_entities:
		if entity.species == species and position.distance_to(entity.position) <= social_range:
			social += 1
	
	# If the animal needs removed, remove it!
	if is_starved() or is_old():
		print(animal_name, " died of starvation at ", position)
		consumed()
		
	# Reproduce if conditions are right
	elif gender == "Female" and reproduction_timer <= 0:
		var all_animals = get_tree().get_nodes_in_group("animals")
		all_animals.shuffle()
		for animal in all_animals:
			if animal.species == species and position.distance_to(animal.position) <= reproduction_range and animal.gender != gender:
				reproduction_timer = reproduction_cooldown
				reproduce()
				break


func set_random_destination():
	var desired_x = (randi() % OhioEcosystemData.grid_size) * OhioEcosystemData.grid_scale
	var desired_z = (randi() % OhioEcosystemData.grid_size) * OhioEcosystemData.grid_scale
	desired_x += randf_range(-8, 8)
	desired_z += randf_range(-8, 8)
	desired_position = Vector3(desired_x, 0, desired_z)


# Position the entity based on a 2d grid
# Note: we set position.z because in 3d, y refers to up/down
func set_grid_position(grid_position: Vector2):
	position.x = grid_position.x * OhioEcosystemData.grid_scale
	position.x += randf_range(-5, 5)
	position.z = grid_position.y * OhioEcosystemData.grid_scale
	position.z += randf_range(-5, 5)
	set_random_destination()
