extends Node


var grass_scene = load("res://Entities/Plants/Grass/grass.tscn")
var deer_scene = load("res://Entities/Animals/Deer/Deer.tscn")
var rabbit_scene = load("res://Entities/Animals/Rabbit/Rabbit.tscn")
var wolf_scene = load("res://Entities/Animals/EasternWolf/EasternWolf.tscn")
var american_goldfinch_scene = load("res://Entities/Animals/AmericanGoldfinch/AmericanGoldfinch.tscn")

var fence_scene = load("res://Props/Artificial/Fence/Fence.tscn")  # Load the fence scene

@onready var esc_menu = $EscMenu
@onready var camera = $Camera


func _ready():
	# Allow the esc menu to talk to the camera, so we know when to block mouse movement
	esc_menu.menu_toggled.connect(_on_esc_menu_toggled)

	# Print size of whole grid
	var grid_bounds_min = -0.5 * OhioEcosystemData.grid_scale
	var grid_bounds_max = (OhioEcosystemData.grid_scale) * (OhioEcosystemData.grid_size - 0.5)
	print("Grid bounds min: ", grid_bounds_min)
	print("Grid bounds max: ", grid_bounds_max)
	# Initialize fences
	for fence in OhioEcosystemData.fences:
		create_fence(fence)
	
	# Proceed with the ecosystem setup
	randomize()
	initialize_ecosystem()
	start_simulation()


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
	for i in range(35):
		var new_deer = deer_scene.instantiate()
		new_deer.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_deer.animal_name = "deer_" + str(OhioEcosystemData.animals_species_data["Deer"]["count"])
		add_child(new_deer)
		OhioEcosystemData.animals_species_data["Deer"]["count"] += 1

	# Add rabbits
	for i in range(35):
		var new_rabbit = rabbit_scene.instantiate()
		new_rabbit.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_rabbit.animal_name = "rabbit_" + str(OhioEcosystemData.animals_species_data["Rabbit"]["count"])
		add_child(new_rabbit)
		OhioEcosystemData.animals_species_data["Rabbit"]["count"] += 1
	
	# Add 5 wolves
	for i in range(30):
		var new_wolf = wolf_scene.instantiate()
		new_wolf.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_wolf.animal_name = "wolf_" + str(OhioEcosystemData.animals_species_data["EasternWolf"]["count"])
		add_child(new_wolf)
		OhioEcosystemData.animals_species_data["EasternWolf"]["count"] += 1

	# Add 5 american goldfinches
	for i in range(35):
		var new_american_goldfinch = american_goldfinch_scene.instantiate()
		new_american_goldfinch.set_grid_position(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size)
		new_american_goldfinch.animal_name = "americanGoldfinch_" + str(OhioEcosystemData.animals_species_data["AmericanGoldfinch"]["count"])
		add_child(new_american_goldfinch)
		OhioEcosystemData.animals_species_data["AmericanGoldfinch"]["count"] += 1


func simulate_day():
	print("Day: ", OhioEcosystemData.days)
	get_tree().call_group("plants", "update")
	get_tree().call_group("animals", "update")


func start_simulation():
	while OhioEcosystemData.days < 1000:
		simulate_day()
		# 50 cycles = 1 day = 4 real life minutes
		await get_tree().create_timer(4.8).timeout
		OhioEcosystemData.days += 0.02


func _on_esc_menu_toggled(is_open: bool):
	camera.block_camera_movement = is_open
