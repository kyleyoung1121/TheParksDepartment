extends CharacterBody3D


# Animal variables; export the ones that we want to tweak in the editor
@export var species: String
@export var speed = 5.0
@export var movement_random_variation: float
@export var eating_distance: float = 2.0
@export var self_scene_path: String

@onready var eye_sight_area = $EyeSightArea
@onready var eye_sight_collision = $EyeSightArea/EyeSightCollision

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

var debug_telepathy_target = "deer_0"

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
	eye_sight_collision.shape = CylinderShape3D.new()
	eye_sight_collision.shape.height = 10
	eye_sight_collision.shape.radius = adjusted_eye_sight
	
	adjusted_eating_distance = eating_distance * OhioEcosystemData.grid_scale * 0.25
	reproduction_range = adjusted_eating_distance
	social_range = adjusted_eye_sight / 4
	
	if animal_name == debug_telepathy_target:
		print("DEBUG: Telepathy target found!")
		$MeshInstance3D.mesh = CapsuleMesh.new()
		$MeshInstance3D.mesh.material = StandardMaterial3D.new()
		$MeshInstance3D.mesh.material.albedo_color = Color(1, 0, 0)


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
	#print("New " + species + " has been born: " + animal_name)
	OhioEcosystemData.animals_species_data[species]["count"] += 1


func decide_movement2():
	# Set a value to help animals decide when to seek food / friends
	var hunger_threshold = 0.4
	var social_threshold = 0.3
	
	# Find current percentage of all needs
	var is_hungry = (float(hunger) / float(max_hunger)) < hunger_threshold
	var is_lonely = (float(social) / float(max_social)) < social_threshold
	
	var nearby_entities = eye_sight_area.get_overlapping_areas()
	
	# Orgnaize nearby entities into predators, friends, or prey
	var nearby_prey: Array
	var nearby_predators: Array
	var nearby_friends: Array
	for entity_area3d in nearby_entities:
		var entity = entity_area3d.get_parent()
		if entity.species in prey_organisms:
			nearby_prey.append(entity)
		elif "prey_organisms" in entity and species in entity.prey_organisms:
			nearby_predators.append(entity)
		elif entity.species == species:
			nearby_friends.append(entity)
	
	## PREDATOR AWARENESS
	# Scan for nearby predators. If any are dangerously close, flee away
	var threat_direction = Vector3()
	for predator in nearby_predators:
		if position.distance_to(predator.position) >= (0.125 * adjusted_eye_sight):
			# Add the vectors, so that an animal can flee from multiple predators at once
			threat_direction += (position - predator.position).normalized()
	# If there are predators nearby, flee in the opposite direction
	if threat_direction.length() > 0:
		var flee_direction = threat_direction.normalized()
		var flee_target_position = position + (flee_direction * adjusted_eye_sight)
		telepathy_print("Predators nearby, running away!")
		set_desired_position(flee_target_position)
		# No other locations should be considered when predators are nearby
		return
	
	## FOOD SEARCH
	# If the animal is hungry, look for the nearest prey and target a close one
	if is_hungry and len(nearby_prey) > 0:
		# Sort the prey options by distance to help decide
		nearby_prey.sort_custom(func(a, b):
			return position.distance_to(a.position) < position.distance_to(b.position)
		)
		
		# Determine which prey to target (should be close, but need not be the closest)
		var i = get_random_portion(len(nearby_prey), "minority")
		telepathy_print("Found prey! " + nearby_prey[i].species)
		set_desired_position(nearby_prey[i].position)
		return
	
	## SOCIAL INTERACTION
	# Sort the animals of the same species by distance
	nearby_friends.sort_custom(func(a, b):
		return position.distance_to(a.position) < position.distance_to(b.position)
	)
	
	# Check if this animal should move towards a mate
	if gender == "Male":
		for friend in nearby_friends:
			if friend.gender == "Female" and friend.reproduction_timer <= 1:
				telepathy_print("Moving to a nearby mate")
				set_desired_position(friend.position)
				return

	# If the animal is lonely, look for the nearest friend and target a close one
	if is_lonely:
		# Determine which friend to target (should be close, but need not be the closest)
		var i = get_random_portion(len(nearby_friends), "minority")
		telepathy_print("Moving towards some friends!")
		set_desired_position(nearby_friends[i].position)
		return
	
	## RANDOM BEHAVIOR
	# At this point, the animal should just do something random.
	var random_choice = randi_range(1, 4)  # Generate a number from 1 to 4
	# 1/4 chance to stand still
	if random_choice == 1:
		telepathy_print("Nothing to do... Standing still")
		set_desired_position(position)
	# 1/4 chance to continue towards previous destination
	if random_choice == 2:
		telepathy_print("Nothing to do... Moving towards desired position")
		pass
	# 2/4 chance to go somewhere random
	if random_choice >= 3:
		telepathy_print("Nothing to do... Going somewhere random!")
		set_random_destination()


func decide_movement():

	# Set a value to help animals decide when to seek food / friends
	var hunger_threshold = 0.4
	var social_threshold = 0.3
	
	# Find current percentage of all needs
	var hunger_percent = float(hunger) / float(max_hunger)
	var social_percent = float(social) / float(max_social)
	
	# The animal will move towards needs with a percentage lower than its threshold
	
	# Find all nearby entities, make a list of them, and score them based on their distance
	# Don't forget about predators and max social group size
	var all_entities = get_tree().get_nodes_in_group("animals") + get_tree().get_nodes_in_group("plants")
	
	# Find all predators that eat this animal, store their positions
	var predator_locations = []
	for entity in all_entities:
		# Check if this entity has prey, and if this animal is included!
		if "prey_organisms" in entity and species in entity.prey_organisms:
			predator_locations.append(entity.position)
	
	# Find all entities that are in range
	var entities_in_range = []
	for entity in all_entities:
		if position.distance_to(entity.position) <= adjusted_eye_sight:
			entities_in_range.append(entity)
	
	# Score each entity based on their distance
	# If a predator is nearby, set a negative score
	# If there are too many of this animal nearby, set a negative score
	var scored_entities = []
	var score
	for entity in entities_in_range:
		if entity.species == species or entity.species in prey_organisms:
			# Score this entity based on distance
			score = position.distance_to(entity.position)
			
			# If there are predators close to this entity, give it a negative score
			for predator in predator_locations:
				if entity.position.distance_to(predator) <= adjusted_eye_sight:
					score = -100
			
			# If there are too many of this species nearby, give this entity a negative score
			# TODO: Should a deer avoid large groups of deer, or is it avoiding large groups of grass?
			var same_species_count = 0
			for other_entity in entities_in_range:
				if other_entity.species == species:
					same_species_count += 1
			if same_species_count >= social_group_size:
				score = -100
			
			# Finally, save this entity and its score
			if score >= 0:
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
	if hunger_percent < hunger_threshold:
		for entity in scored_entities:
			entity = entity.entity
			if entity.species in prey_organisms:
				set_desired_position(entity.position)
				return
	
	# If the animal is lonely, move towards social
	elif social_percent < social_threshold:
		for entity in scored_entities:
			entity = entity.entity
			if entity.species == species:
				set_desired_position(entity.position)
				return
	
	# If the animal is neither hungry nor lonely
	else:
		for entity in scored_entities:
			if entity.score <= 0:
				continue
			entity = entity.entity
			if entity.species == species and entity.gender == "Female" and entity.reproduction_timer <= 1: # move towards mate
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
	
	# TODO: I think it is possible for an Omnivore to eat twice. One plant, one animal. Correct this!
	# Eat if possible/needed
	if hunger < max_hunger:
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
						break
		
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
						break

	# For every entity of same species in range, increase social
	var all_entities = get_tree().get_nodes_in_group("animals")
	for entity in all_entities:
		if entity.species == species and position.distance_to(entity.position) <= social_range:
			social += 1
		# If this animal meets or exceeds it's social max, we can stop searching
		if social >= max_social:
			social = max_social
			break
	
	# If the animal needs removed, remove it!
	if is_starved():
		#print(animal_name, " died of starvation at ", position)
		consumed()
	if is_old():
		#print(animal_name, " died of old age at ", position)
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
	set_desired_position(Vector3(desired_x, 0, desired_z))


# Position the entity based on a 2d grid
# Note: we set position.z because in 3d, y refers to up/down
func set_grid_position(grid_position: Vector2):
	position.x = grid_position.x * OhioEcosystemData.grid_scale
	position.x += randf_range(-5, 5)
	position.z = grid_position.y * OhioEcosystemData.grid_scale
	position.z += randf_range(-5, 5)
	set_random_destination()


func telepathy_print(text):
	if animal_name == debug_telepathy_target:
		print(text)
