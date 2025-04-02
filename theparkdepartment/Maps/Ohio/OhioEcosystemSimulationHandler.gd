extends Node


var grass_scene = load("res://Entities/Plants/Grass/grass.tscn")
var deer_scene = load("res://Entities/Animals/Deer/Deer.tscn")
var rabbit_scene = load("res://Entities/Animals/Rabbit/Rabbit.tscn")
var wolf_scene = load("res://Entities/Animals/EasternWolf/EasternWolf.tscn")
var american_goldfinch_scene = load("res://Entities/Animals/AmericanGoldfinch/AmericanGoldfinch.tscn")
var coopers_hawk_scene = load("res://Entities/Animals/CoopersHawk/CoopersHawk.tscn")

var fence_scene = load("res://Props/Artificial/Fence/Fence.tscn")  # Load the fence scene

@onready var in_game_menu = $InGameMenu
@onready var object_placement = $ObjectPlacement

func _ready():
	# Print size of whole grid
	var grid_bounds_min = -0.5 * OhioEcosystemData.grid_scale
	var grid_bounds_max = (OhioEcosystemData.grid_scale) * (OhioEcosystemData.grid_size - 0.5)
	print("Grid bounds min: ", grid_bounds_min)
	print("Grid bounds max: ", grid_bounds_max)
	
	in_game_menu.start_object_placement.connect(_on_start_object_placement)
	
	# Initialize fences
	for fence in OhioEcosystemData.fences:
		create_fence(fence)
	
	# Proceed with the ecosystem setup
	randomize()
	initialize_ecosystem()
	start_simulation()
	
	guest_system()


func create_fence(edges: Array):
	var new_fence = fence_scene.instantiate()
	new_fence.edges = edges
	add_child(new_fence)

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


func simulate_day():
	print("Day: ", OhioEcosystemData.days)
	get_tree().call_group("plants", "update")
	get_tree().call_group("animals", "update")
	print("End of Day: ", OhioEcosystemData.days)


func start_simulation():
	while OhioEcosystemData.days < 300:
		simulate_day()
		# Wait between days
		await get_tree().create_timer(2).timeout
		OhioEcosystemData.days += 1


func _on_start_object_placement(structure_type):
	object_placement.start_placing(structure_type)


func guest_system():
	# Seven sets of movement for each straight section of the path
	var i = 1
	# max of 5 guests for now
	while i < 6:
		guest_movement(i)
		print(i, " is moving")
		await get_tree().create_timer(15).timeout
		i += 1
		if i == 6:
			i = 1
	
	print("out-of-loop is moving")


func give_money():
	# link money variable to UI
	emit_signal("update_funds")

func guest_movement(guestNum):
	give_money()
	
	#1
	for i in range(585):
		get_node("Guests/Guest" + str(guestNum)).position.x += 0.1
		await get_tree().create_timer(0.01).timeout
	
	#2
	for i in range(700):
		get_node("Guests/Guest" + str(guestNum)).position.z += 0.1
		await get_tree().create_timer(0.01).timeout
	
	#3
	for i in range(393):
		get_node("Guests/Guest" + str(guestNum)).position.x -= 0.1
		await get_tree().create_timer(0.01).timeout
	
	#4
	for i in range(482):
		get_node("Guests/Guest" + str(guestNum)).position.z += 0.1
		await get_tree().create_timer(0.01).timeout
	
	#5
	for i in range(1137):
		get_node("Guests/Guest" + str(guestNum)).position.x += 0.1
		await get_tree().create_timer(0.01).timeout
		
	#6
	for i in range(1315):
		get_node("Guests/Guest" + str(guestNum)).position.z -= 0.1
		await get_tree().create_timer(0.01).timeout
		
	#7
	for i in range(400):
		get_node("Guests/Guest" + str(guestNum)).position.x += 0.1
		await get_tree().create_timer(0.01).timeout
	
	get_node("Guests/Guest" + str(guestNum)).position.x = -14
	get_node("Guests/Guest" + str(guestNum)).position.z = 18.3
