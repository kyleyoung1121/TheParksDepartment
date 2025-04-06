extends Node


var grass_scene = load("res://Entities/Plants/Grass/grass.tscn")
var deer_scene = load("res://Entities/Animals/Deer/Deer.tscn")
var rabbit_scene = load("res://Entities/Animals/Rabbit/Rabbit.tscn")
var wolf_scene = load("res://Entities/Animals/EasternWolf/EasternWolf.tscn")
var american_goldfinch_scene = load("res://Entities/Animals/AmericanGoldfinch/AmericanGoldfinch.tscn")
var coopers_hawk_scene = load("res://Entities/Animals/CoopersHawk/CoopersHawk.tscn")
var coyote_scene = load("res://Entities/Animals/Coyote/Coyote.tscn")


func _ready():
	# Print size of whole grid
	var grid_bounds_min = -0.5 * OhioEcosystemData.grid_scale
	var grid_bounds_max = (OhioEcosystemData.grid_scale) * (OhioEcosystemData.grid_size - 0.5)
	print("Grid bounds min: ", grid_bounds_min)
	print("Grid bounds max: ", grid_bounds_max)
	
	# Proceed with the ecosystem setup
	randomize()
	initialize_ecosystem()
	start_simulation()


func initialize_ecosystem():
	# Add plants in every grid spot
	for i in range(OhioEcosystemData.grid_size):
		for j in range(OhioEcosystemData.grid_size):
			var plant_quantity = randi_range(3,5)
			for k in range(plant_quantity):
				# Create a new instance of the grass scene.
				var new_plant = grass_scene.instantiate()
				new_plant.set_grid_position(i, j)
				new_plant.plant_name = "grass_" + str(OhioEcosystemData.plants_species_data["Grass"]["count"])
				add_child(new_plant)
				# Keep track of population in the global Ohio data
				OhioEcosystemData.plants_species_data["Grass"]["count"] += 1
	
	# Add deer
	for i in range(15):
		var new_deer = deer_scene.instantiate()
		new_deer.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_deer.animal_name = "deer_" + str(OhioEcosystemData.animals_species_data["Deer"]["count"])
		add_child(new_deer)
		OhioEcosystemData.animals_species_data["Deer"]["count"] += 1

	# Add rabbits
	for i in range(15):
		var new_rabbit = rabbit_scene.instantiate()
		new_rabbit.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_rabbit.animal_name = "rabbit_" + str(OhioEcosystemData.animals_species_data["Rabbit"]["count"])
		add_child(new_rabbit)
		OhioEcosystemData.animals_species_data["Rabbit"]["count"] += 1
	
	# Add 5 wolves
	for i in range(10):
		var new_wolf = wolf_scene.instantiate()
		new_wolf.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_wolf.animal_name = "wolf_" + str(OhioEcosystemData.animals_species_data["EasternWolf"]["count"])
		add_child(new_wolf)
		OhioEcosystemData.animals_species_data["EasternWolf"]["count"] += 1

	# Add 5 american goldfinches
	for i in range(15):
		var new_american_goldfinch = american_goldfinch_scene.instantiate()
		new_american_goldfinch.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_american_goldfinch.animal_name = "americanGoldfinch_" + str(OhioEcosystemData.animals_species_data["AmericanGoldfinch"]["count"])
		add_child(new_american_goldfinch)
		OhioEcosystemData.animals_species_data["AmericanGoldfinch"]["count"] += 1

	# Add 5 Cooper's Hawks
	for i in range(5):
		var new_coopers_hawk = coopers_hawk_scene.instantiate()
		new_coopers_hawk.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_coopers_hawk.animal_name = "coopersHawk_" + str(OhioEcosystemData.animals_species_data["CoopersHawk"]["count"])
		add_child(new_coopers_hawk)
		OhioEcosystemData.animals_species_data["CoopersHawk"]["count"] += 1
		
	# add 5 Coyote
	for i in range(5):
		var new_coyote = coyote_scene.instantiate()
		new_coyote.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_coyote.animal_name = "coyote_" + str(OhioEcosystemData.animals_species_data["Coyote"]["count"])
		add_child(new_coyote)
		OhioEcosystemData.animals_species_data["Coyote"]["count"] += 1


func simulate_day():
	print("Cycle: ", OhioEcosystemData.cycle_count)
	get_tree().call_group("plants", "update")
	get_tree().call_group("animals", "update")
	print("End of Day: ", OhioEcosystemData.cycle_count)


func start_simulation():
	while true:
		simulate_day()
		# Wait between cycles
		await get_tree().create_timer(2).timeout
		OhioEcosystemData.cycle_count += 1
