extends Node

# TODO: make a grass scene and link it here OR make this export and do it in editor
var grass_scene
var deer_scene
var rabbit_scene
var wolf_scene


# TODO: Replace the "data" parameter with referencing the new global data script: OhioEcosystemData
#print("DEBUG: SimulationHandler is trying to print grid_size: ", OhioEcosystemData.grid_size)
func initialize_ecosystem():
	# Put one plant at each coordinate
	for i in range(OhioEcosystemData.grid_size): # example of how to use global script
		for j in range(data["grid_size"]):
			var new_plant = grass_scene.new(Vector2(i, j))
			data["plant_species_data"]["Grass"]["count"] += 1
			data["plants"]["grass_" + str(data["plant_species_data"]["Grass"]["count"])] = new_plant
		
	for i in range(5):
		var deer = deer_scene.new()
		data["animal_species_data"]["Deer"]["count"] += 1
		deer.init(Vector2(randi() % data["grid_size"], randi() % data["grid_size"]), "deer_" + str(data["animal_species_data"]["Deer"]["count"]), data)
		data["animals"][deer.name] = deer

	for i in range(5):
		var rabbit = rabbit_scene.new()
		data["animal_species_data"]["Rabbit"]["count"] += 1
		rabbit.init(Vector2(randi() % data["grid_size"], randi() % data["grid_size"]), "rabbit_" + str(data["animal_species_data"]["Rabbit"]["count"]), data)
		data["animals"][rabbit.name] = rabbit
	
	for i in range(5):
		var wolf = wolf_scene.new()
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
	initialize_ecosystem()
	start_simulation()
