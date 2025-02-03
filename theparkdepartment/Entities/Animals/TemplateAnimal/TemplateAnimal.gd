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
var eye_sight: int
var movement_chance: float
var reproduction_cooldown: int
var reproduction_timer: int
var desired_position = Vector3()

# TODO: Should we just set the original variable, or separate like this?
var adjusted_eye_sight: float
var adjusted_eating_distance: float


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
	
	# Set initial conditions
	hunger = get_random_portion(max_hunger, "majority")
	reproduction_timer = get_random_portion(reproduction_cooldown, "majority") 
	age = 0 + get_random_portion(max_age, "minority")
	speed *= randf_range(0.8, 1.2)
	
	# Randomly assign gender
	gender = "Male" if randi() % 2 == 0 else "Female"
	
	# TODO: Determine how distance works. Maybe 1 eye_sight = 1/4 grid?
	adjusted_eye_sight = eye_sight * OhioEcosystemData.grid_scale * 0.25
	adjusted_eating_distance = eating_distance * OhioEcosystemData.grid_scale * 0.25


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


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# TODO: Verify that the following code moves the animal towards its desired location
	# Determine what direction the animal wants to move in
	var direction = (desired_position - position).normalized()
	# Move in the x and z directions as needed (y is height, so ignore it for now)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
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


func eat():
	# If we are already full, don't eat anything nearby
	if hunger >= max_hunger:
		return false
	
	# Consider all plants and animals. If they are prey and it range, eat them
	if diet_type == "Herbavore" or diet_type == "Omnivore":
		var all_plants = get_tree().get_nodes_in_group("plants")
		all_plants.shuffle()
		for food_consideration in all_plants:
			# Only consider eating known prey_organisms
			if food_consideration.species in prey_organisms:
				# If the food is in range, eat it!
				if position.distance_to(food_consideration.position) <= adjusted_eating_distance:
					hunger = min(hunger + OhioEcosystemData.plants_species_data[food_consideration.species]["nutrition"], max_hunger)
					food_consideration.consumed()
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
					#print(animal_name, " ate ", food_consideration.animal_name)
					return true
	


func decrease_hunger(amount):
	hunger -= amount


func is_starved() -> bool:
	return hunger <= 0


func is_old() -> bool:
	return age >= max_age


func consumed():
	queue_free()


func reproduce(count):
	# Get the parent scene so we can add the new instance to it
	var parent = get_parent()
	assert(not parent == null)
	
	# Check that this species hasn't hit its limit
	var population_limit = OhioEcosystemData.animals_species_data[species]["population_limit"]
	if OhioEcosystemData.animals_species_data[species]["count"] >= population_limit:
		print("flag 1")
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


func search_for_need():
	if gender == "Male" and hunger > max_hunger * 0.5:
		var all_animals = get_tree().get_nodes_in_group("animals")
		all_animals.shuffle()
		for animal in all_animals:
			if animal.species == species and animal.gender == "Female" and animal.reproduction_timer <= 1:
				if position.distance_to(animal.position) <= adjusted_eye_sight:
					set_desired_position(animal.position)
					return
	
	# Otherwise, search for food
	# If this animal eats meat, look for animals
	if diet_type == "Carnivore" or diet_type == "Omnivore":
		var all_animals = get_tree().get_nodes_in_group("animals")
		all_animals.shuffle()
		for animal in all_animals:
			if animal.position.distance_to(position) <= adjusted_eye_sight and animal.species in prey_organisms:
				set_desired_position(animal.position)
				return
	
	# If this animal eats plants, look for plants
	if diet_type == "Herbivore" or diet_type == "Omnivore":
		var all_plants = get_tree().get_nodes_in_group("plants")
		all_plants.shuffle()
		for plant in all_plants:
			if plant.position.distance_to(position) <= adjusted_eye_sight and plant.species in prey_organisms:
				set_desired_position(plant.position)
				return
	
	# If no mate or food is found, choose randomly
	var pathing_choice = randi() % 3
	# 1/3 of the time, go somewhere random
	if pathing_choice == 0:
		set_random_destination()
	# 1/3 of the time, stay put
	elif pathing_choice == 1:
		desired_position = position
	# 1/3 of the time, continue towards last desired position
	else:
		pass

func move():
	if decide_to_move():
		search_for_need()


func update():
	move()
	age += 1
	reproduction_timer -= 1
	hunger -= 1

	# Eat if possible/needed
	eat()
	
	# If the animal needs removed, remove it!
	if is_starved() or is_old():
		print(animal_name, " died of starvation at ", position)
		consumed()
		
	# Reproduce if conditions are right
	elif gender == "Female" and reproduction_timer <= 0:
		var all_animals = get_tree().get_nodes_in_group("animals")
		all_animals.shuffle()
		for animal in all_animals:
			if animal.species == species and position.distance_to(animal.position) and animal.gender != gender:
				reproduction_timer = reproduction_cooldown
				reproduce(OhioEcosystemData.animals_species_data[species]["count"])
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
