extends CharacterBody3D


# Animal variables; export the ones that we want to tweak in the editor
@export var animal_name: String
@export var species: String
@export var speed = 5.0
@export var movement_random_variation: float
@export var gender: String
@export var eating_distance: float = 5.0
# TODO: Work out how to handle reproduction. Do we just spawn another copy of this scene?
@export var self_scene = null

var age: int
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
	hunger = max_hunger
	reproduction_timer = reproduction_cooldown
	age = 0
	
	# Unless explicitly set, randomly assign gender
	if gender == null:
		gender = "Male" if randi() % 2 == 0 else "Female"
	
	# TODO: Determine how distance works. Maybe 1 eye_sight = 1/4 grid?
	adjusted_eye_sight = eye_sight * OhioEcosystemData.grid_scale * 0.25
	adjusted_eating_distance = eating_distance * OhioEcosystemData.grid_scale * 0.25


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

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
	var all_animals = get_tree().get_nodes_in_group("animals")
	var all_plants = get_tree().get_nodes_in_group("plants")
	var all_plants_and_animals = all_animals + all_plants
	for food_consideration in all_plants_and_animals:
		# Only consider eating known prey_organisms
		if food_consideration.species in prey_organisms:
			# If the food is in range, eat it!
			if position.distance_to(food_consideration.position) <= adjusted_eating_distance:
				hunger = min(hunger + OhioEcosystemData.animals_species_data[food_consideration.species]["nutrition"], max_hunger)
				food_consideration.consumed()
				print(animal_name, " ate ", food_consideration.animal_name)
				return true


func decrease_hunger(amount):
	hunger -= amount


func is_starved() -> bool:
	return hunger <= 0


func is_old() -> bool:
	return age >= max_age


func consumed():
	print(animal_name + " was deleted!!")
	queue_free()


func reproduce(count: int):
	var baby_organism = self_scene
	baby_organism.init(position, species.to_lower() + "_" + str(count))
	print("Baby ", species, " created with name: ", baby_organism.animal_name)
	return baby_organism


func search_for_need():
	if gender == "Male" and hunger > max_hunger * 0.5:
		for animal in get_tree().get_nodes_in_group("animals"):
			if animal.species == species and animal.gender == "Female" and animal.reproduction_timer <= 2:
				if position.distance_to(animal.position) <= adjusted_eye_sight:
					set_desired_position(animal.position)
					return
	
	else:
		# Search for food
		# If this animal eats meat, look for animals
		if diet_type == "Carnivore" or diet_type == "Omnivore":
			for animal in get_tree().get_nodes_in_group("animals"):
				if animal.position.distance_to(position) <= adjusted_eye_sight and animal.species in prey_organisms:
					set_desired_position(animal.position)
					return
		
		# If this animal eats plants, look for plants
		if diet_type == "Herbivore" or diet_type == "Omnivore":
			for plant in get_tree().get_nodes_in_group("plants"):
				if plant.position.distance_to(position) <= adjusted_eye_sight and plant.species in prey_organisms:
					set_desired_position(plant.position)
					return


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
		for animal in get_tree().get_nodes_in_group("animals"):
			if animal.species == species and animal.position == position and animal.gender != gender:
				print(animal_name, " and ", animal.animal_name, " reproducing at ", position)
				reproduction_timer = reproduction_cooldown
				var new_animal = reproduce(OhioEcosystemData.animal_species_data[species]["count"])
				OhioEcosystemData.animal_species_data[species]["count"] += 1
				# TODO: add the new animal to the scene


# Position the entity based on a 2d grid
# Note: we set position.z because in 3d, y refers to up/down
func set_grid_position(grid_position: Vector2):
	position.x = grid_position.x * OhioEcosystemData.grid_scale
	position.z = grid_position.y * OhioEcosystemData.grid_scale
