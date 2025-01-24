extends CharacterBody3D


# TODO: Update starter code
# TODO: Move this code to a more intuitive spot in this file (below variables)
# This controls movement. It's mostly starter code for now
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# TODO: Redo starter code to choose a direction programatically
	# This starter code is trying to connect keyboard input to movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# This applies our new velocity
	move_and_slide()


# Animal variables; export the ones that we want to tweak in the editor
@export var speed = 5.0
var animal_position: Vector2 # Changed var name to avoid keyword "position"
var hunger: int
var reproduction_timer: int
@export var reproduction_cooldown: int
@export var max_hunger: int
@export var animal_name: String # Changed var name to avoid keyword "name"
var species: String
@export var gender: String
@export var eye_sight: int
@export var movement_chance: float
var age: int
@export var max_age: int
@export var nutrition: int
@export var diet_type: String
@export var prey_organisms: Array # Made plural
# TODO: Work out how to handle reproduction. Do we just spawn another copy of this scene?
@export var self_scene = null

func eat(data):
	# TODO: Leave comment here
	if hunger >= max_hunger:
		return false
	
	# If this animal is a herbivore, check for nearby plants
	if diet_type == "Herbivore":
		for key in data["plants"].keys():
			var plant = data["plants"][key]
			# TODO: Check if any nodes in group "Plants" are nearby.
			# TODO: Might need to attach an area3d to check "close enough"
			if plant.position == position:
				# If a nearby plant is found
				data["plants"].erase(key)
				hunger = min(hunger + nutrition, max_hunger)
				return true
	
	# If this animal is a carnivore, check for nearby animals
	elif diet_type == "Carnivore":
		for key in data["animals"].keys():
			var prey = data["animals"][key]
			# TODO: Check if any nodes in group "Animals" are nearby.
			# TODO: Might need to attach an area3d to check "close enough"
			if prey.position == position and prey.species in prey_organisms:
				hunger = min(hunger + prey["nutrition"], max_hunger)
				data["animals"].erase(key)
				print(name, " ate ", prey.name)
				return true
	
	# TODO: Explain what situation is tied to this else statement
	# Omnivore?
	else:
		for key in data["plants"].keys():
			var plant = data["plants"][key]
			if plant.position == position:
				data["plants"].erase(key)
				hunger = min(hunger + nutrition, max_hunger)
				return true
		for key in data["animals"].keys():
			var prey = data["animals"][key]
			if prey.position == position and prey.species in prey_organisms:
				hunger = min(hunger + prey["nutrition"], max_hunger)
				data["animals"].erase(key)
				return true

func check_if_moving():
	return randf() < movement_chance

func decrease_hunger(amount):
	hunger -= amount

func is_starved() -> bool:
	return hunger <= 0

func is_old() -> bool:
	return age >= max_age

func reproduce(count: int, data):
	var baby_organism = self_scene
	baby_organism.init(position, species.to_lower() + "_" + str(count), data)
	print("Baby ", species, " created with name: ", baby_organism.name)
	return baby_organism

func search_for_need(data):
	if gender == "Male" and hunger > max_hunger * 0.5:
		for key in data["animals"].keys():
			var other = data["animals"][key]
			if other.species == species and other.gender == "Female" and other.reproduction_timer <= 2:
				if position.distance_to(other.position) <= eye_sight:
					var direction = (other.position - position).normalized()
					# TODO: Update code to use physics_process for movement
					position += Vector2(sign(direction.x), sign(direction.y))
					return
	
	else:
		# Search for food
		# if carnivore, search for prey
		if diet_type == "Carnivore":
			for key in data["animals"].keys():
				var prey = data["animals"][key]
				if prey.position.distance_to(position) <= eye_sight and prey.species in prey_organisms:
					var direction = (prey.position - position).normalized()
					# TODO: Update code to use physics_process for movement
					position += Vector2(sign(direction.x), sign(direction.y))
					return
					
		if diet_type == "Herbivore":
			# if herbivore, search for plants
			for key in data["plants"].keys():
				var plant = data["plants"][key]
				if plant.position.distance_to(position) <= eye_sight:
					var direction = (plant.position - position).normalized()
					# TODO: Update code to use physics_process for movement
					position += Vector2(sign(direction.x), sign(direction.y))
					return
		else:
			# if omnivore, search for both
			for key in data["plants"].keys():
				var plant = data["plants"][key]
				if plant.position.distance_to(position) <= eye_sight:
					var direction = (plant.position - position).normalized()
					# TODO: Update code to use physics_process for movement
					position += Vector2(sign(direction.x), sign(direction.y))
					return
			for key in data["animals"].keys():
				var prey = data["animals"][key]
				if prey.position.distance_to(position) <= eye_sight and prey.species in ["Deer", "Rabbit"]:
					var direction = (prey.position - position).normalized()
					# TODO: Update code to use physics_process for movement
					position += Vector2(sign(direction.x), sign(direction.y))
					return

func move(data):
	if check_if_moving():
		search_for_need(data)

func update(data):
	move(data)
	age += 1
	reproduction_timer -= 1
	hunger -= 1

	# Get the organism to eat
	eat(data)
	
	if is_starved() or is_old():
		print(name, " died of starvation at ", position)
		data["animals"].erase(name)
	elif gender == "Female" and reproduction_timer <= 0:
		for key in data["animals"].keys():
			var other = data["animals"][key]
			if other.species == species and other.position == position and other.gender != gender:
				print(name, " and ", other.name, " reproducing at ", position)
				reproduction_timer = reproduction_cooldown
				var new_animal = reproduce(data["animal_species_data"][species]["count"], data)
				data["animal_species_data"][species]["count"] += 1
				data["animals"][new_animal.name] = new_animal
