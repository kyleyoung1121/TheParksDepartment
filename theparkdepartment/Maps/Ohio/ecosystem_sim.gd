extends Node

class_name Organism

# Define a dictionary for ecosystem data
var ecosystem_data = {
	"grid_size": 10,
	"plants": {},
	"animals": {},
	"days": 0,
	"animal_species_data": {
		"Deer": {
			"count": 0,
			"reproduction_cooldown": 10,
			"max_hunger": 5,
			"eye_sight": 4,
			"movement_chance": 1,
			"max_age": 15,
			"nutrition" : 5,
			"type": "Herbivore",
			"prey_organism": ["Grass"]
		},
		"Rabbit": {
			"count": 0,
			"reproduction_cooldown": 8,
			"max_hunger": 5,
			"eye_sight": 3,
			"movement_chance": 1,
			"max_age": 10,
			"nutrition" : 3,
			"type": "Herbivore",
			"prey_organism": ["Grass"]
		},
		"Wolf": {
			"count": 0,
			"reproduction_cooldown": 12,
			"max_hunger": 5,
			"eye_sight": 6,
			"movement_chance": 1,
			"max_age": 20,
			"nutrition" : 1,
			"type": "Carnivore",
			"prey_organism": ["Deer", "Rabbit"]
		}
	},
	"plant_species_data": {
		"Grass": {
			"count": 0
		}
	}
}

# Base class for all organisms
class BaseOrganism:
	var position: Vector2
	var hunger: int
	var reproduction_timer: int
	var reproduction_cooldown: int
	var max_hunger: int
	var name: String
	var species: String
	var gender: String
	var eye_sight: int
	var movement_chance: float
	var age: int
	var max_age: int
	var nutrition: int
	var type: String
	var prey_organism: Array

	func eat(data):
		if self.hunger >= self.max_hunger:
			return false
		if self.type == "Herbivore":
			for key in data["plants"].keys():
				var plant = data["plants"][key]
				if plant.position == position:
					data["plants"].erase(key)
					hunger = min(hunger + nutrition, max_hunger)
					return true
		elif self.type == "Carnivore":
			for key in data["animals"].keys():
				var prey = data["animals"][key]
				if prey.position == position and prey.species in prey_organism:
					hunger = min(hunger + prey["nutrition"], max_hunger)
					data["animals"].erase(key)
					print(name, " ate ", prey.name)
					return true
		else:
			for key in data["plants"].keys():
				var plant = data["plants"][key]
				if plant.position == position:
					data["plants"].erase(key)
					hunger = min(hunger + nutrition, max_hunger)
					return true
			for key in data["animals"].keys():
				var prey = data["animals"][key]
				if prey.position == position and prey.species in prey_organism:
					hunger = min(hunger + prey["nutrition"], max_hunger)
					data["animals"].erase(key)
					return true

	func check_if_moving():
		return randf() < self.movement_chance

	func decrease_hunger(amount):
		hunger -= amount

	func is_starved() -> bool:
		return hunger <= 0

	func is_old() -> bool:
		return age >= max_age

	func reproduce(count: int, data):
		var baby_organism = null
		if species == "Deer":
			baby_organism = Deer.new()
		elif species == "Rabbit":
			baby_organism = Rabbit.new()
		elif species == "Wolf":
			baby_organism = Wolf.new()
		
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
						position += Vector2(sign(direction.x), sign(direction.y))
						return
		else:
			# Search for food
			# if carnivore, search for prey
			if self.type == "Carnivore":
				for key in data["animals"].keys():
					var prey = data["animals"][key]
					if prey.position.distance_to(position) <= eye_sight and prey.species in self.prey_organism:
						var direction = (prey.position - position).normalized()
						position += Vector2(sign(direction.x), sign(direction.y))
						return
			if self.type == "Herbivore":
				# if herbivore, search for plants
				for key in data["plants"].keys():
					var plant = data["plants"][key]
					if plant.position.distance_to(position) <= eye_sight:
						var direction = (plant.position - position).normalized()
						position += Vector2(sign(direction.x), sign(direction.y))
						return
			else:
				# if omnivore, search for both
				for key in data["plants"].keys():
					var plant = data["plants"][key]
					if plant.position.distance_to(position) <= eye_sight:
						var direction = (plant.position - position).normalized()
						position += Vector2(sign(direction.x), sign(direction.y))
						return
				for key in data["animals"].keys():
					var prey = data["animals"][key]
					if prey.position.distance_to(position) <= eye_sight and prey.species in ["Deer", "Rabbit"]:
						var direction = (prey.position - position).normalized()
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
		self.eat(data)
		
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

class Deer extends BaseOrganism:
	func init(init_position: Vector2, init_name: String, data):
		position = init_position
		name = init_name
		species = "Deer"
		gender = "Male" if randi() % 2 == 0 else "Female"
		max_hunger = data["animal_species_data"][species]["max_hunger"]
		hunger = max_hunger
		reproduction_cooldown = data["animal_species_data"][species]["reproduction_cooldown"]
		reproduction_timer = reproduction_cooldown
		eye_sight = data["animal_species_data"][species]["eye_sight"]
		movement_chance = data["animal_species_data"][species]["movement_chance"]
		max_age = data["animal_species_data"][species]["max_age"]
		nutrition = data["animal_species_data"][species]["nutrition"]
		type = data["animal_species_data"][species]["type"]
		prey_organism = data["animal_species_data"][species]["prey_organism"]

class Rabbit extends BaseOrganism:
	func init(init_position: Vector2, init_name: String, data):
		position = init_position
		name = init_name
		species = "Rabbit"
		gender = "Male" if randi() % 2 == 0 else "Female"
		max_hunger = data["animal_species_data"][species]["max_hunger"]
		hunger = max_hunger
		reproduction_cooldown = data["animal_species_data"][species]["reproduction_cooldown"]
		reproduction_timer = reproduction_cooldown
		eye_sight = data["animal_species_data"][species]["eye_sight"]
		movement_chance = data["animal_species_data"][species]["movement_chance"]
		max_age = data["animal_species_data"][species]["max_age"]
		nutrition = data["animal_species_data"][species]["nutrition"]
		type = data["animal_species_data"][species]["type"]
		prey_organism = data["animal_species_data"][species]["prey_organism"]

class Wolf extends BaseOrganism:
	func init(init_position: Vector2, init_name: String, data):
		position = init_position
		name = init_name
		species = "Wolf"
		gender = "Male" if randi() % 2 == 0 else "Female"
		max_hunger = data["animal_species_data"][species]["max_hunger"]
		hunger = max_hunger
		reproduction_cooldown = data["animal_species_data"][species]["reproduction_cooldown"]
		reproduction_timer = reproduction_cooldown
		eye_sight = data["animal_species_data"][species]["eye_sight"]
		movement_chance = data["animal_species_data"][species]["movement_chance"]
		max_age = data["animal_species_data"][species]["max_age"]
		nutrition = data["animal_species_data"][species]["nutrition"]
		type = data["animal_species_data"][species]["type"]
		prey_organism = data["animal_species_data"][species]["prey_organism"]

class Grass:
	var position: Vector2
	func _init(init_position: Vector2):
		position = init_position

	func update(data):
		# every turn grass reproduces into adjacent cells if there is no organism in that cell
		var new_grass = null
		var new_position = null
		var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

		for direction in directions:
			new_position = position + direction
			if not data["plants"].has(new_position) and new_position.x >= 0 and new_position.x < data["grid_size"] and new_position.y >= 0 and new_position.y < data["grid_size"]:
				new_grass = Grass.new(new_position)
				data["plant_species_data"]["Grass"]["count"] += 1
				data["plants"]["grass_" + str(data["plant_species_data"]["Grass"]["count"])] = new_grass

func initialize_ecosystem(data):
	# Put one plant at each coordinate
	for i in range(data["grid_size"]):
		for j in range(data["grid_size"]):
			var new_plant = Grass.new(Vector2(i, j))
			data["plant_species_data"]["Grass"]["count"] += 1
			data["plants"]["grass_" + str(data["plant_species_data"]["Grass"]["count"])] = new_plant
		
	for i in range(5):
		var deer = Deer.new()
		data["animal_species_data"]["Deer"]["count"] += 1
		deer.init(Vector2(randi() % data["grid_size"], randi() % data["grid_size"]), "deer_" + str(data["animal_species_data"]["Deer"]["count"]), data)
		data["animals"][deer.name] = deer

	for i in range(5):
		var rabbit = Rabbit.new()
		data["animal_species_data"]["Rabbit"]["count"] += 1
		rabbit.init(Vector2(randi() % data["grid_size"], randi() % data["grid_size"]), "rabbit_" + str(data["animal_species_data"]["Rabbit"]["count"]), data)
		data["animals"][rabbit.name] = rabbit
	
	for i in range(5):
		var wolf = Wolf.new()
		data["animal_species_data"]["Wolf"]["count"] += 1
		wolf.init(Vector2(randi() % data["grid_size"], randi() % data["grid_size"]), "wolf_" + str(data["animal_species_data"]["Wolf"]["count"]), data)
		data["animals"][wolf.name] = wolf

	return data

func simulate_day(data):
	print("Day", data["days"])
	for key in data["plants"].keys():
		data["plants"][key].update(data)

	for key in data["animals"].keys():
		data["animals"][key].update(data)

	print("End of Day", data["days"])
	return data

func start_simulation(data):
	while data["days"] < 100:
		data = simulate_day(data)
		data["days"] += 1

func _ready():
	randomize()
	initialize_ecosystem(ecosystem_data)
	start_simulation(ecosystem_data)
