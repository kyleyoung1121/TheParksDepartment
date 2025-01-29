extends Node


# TODO: make a grass scene and link it here OR make this export and do it in editor
var grass_scene
var deer_scene
var rabbit_scene
var wolf_scene


func initialize_ecosystem():
	# Add 1 plant in every spot in our grid
	for i in range(OhioEcosystemData.grid_size):
		for j in range(OhioEcosystemData.grid_size):
			# Create a new instance of our grass scene.
			# TODO: Does passing the coord in the new() function work?
			var new_plant = grass_scene.new(Vector2(i, j))
			OhioEcosystemData.plant_species_data["Grass"]["count"] += 1
			# Set a name that includes the count
			# TODO: Make sure the plant scene is expecting this id variable!
			new_plant.id = "grass_" + str(OhioEcosystemData.plant_species_data["Grass"]["count"])
	
	# Add 5 deer
	for i in range(5):
		var new_deer = deer_scene.new()
		OhioEcosystemData.animals_species_data["Deer"]["count"] += 1
		# TODO: Make sure the animal scene is expecting the spawn coords and name
		new_deer.init(Vector2(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size), "deer_" + str(OhioEcosystemData.animals_species_data["Deer"]["count"]))

	# Add 5 rabbits
	for i in range(5):
		var new_rabbit = rabbit_scene.new()
		OhioEcosystemData.animals_species_data["Rabbit"]["count"] += 1
		# TODO: Make sure the animal scene is expecting the spawn coords and name
		new_rabbit.init(Vector2(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size), "rabbit_" + str(OhioEcosystemData.animals_species_data["Rabbit"]["count"]))

	# Add 5 wolves
	for i in range(5):
		var new_wolf = wolf_scene.new()
		OhioEcosystemData.animals_species_data["Wolf"]["count"] += 1
		# TODO: Make sure the animal scene is expecting the spawn coords and name
		new_wolf.init(Vector2(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size), "wolf_" + str(OhioEcosystemData.animals_species_data["Wolf"]["count"]))


func simulate_day():
	print("Day: ", OhioEcosystemData.days)
	get_tree().call_group("plants", "update")
	get_tree().call_group("animals", "update")
	print("End of Day: ", OhioEcosystemData.days)


func start_simulation():
	while OhioEcosystemData.days < 100:
		simulate_day()
		# Wait between days
		await get_tree().create_timer(5.0).timeout
		OhioEcosystemData.days += 1

func _ready():
	randomize()
	initialize_ecosystem()
	start_simulation()
