extends Node


var grass_scene = load("res://Entities/Plants/Grass/grass.tscn")
var deer_scene = load("res://Entities/Animals/Deer/Deer.tscn")
var rabbit_scene = load("res://Entities/Animals/Rabbit/Rabbit.tscn")
var wolf_scene = load("res://Entities/Animals/EasternWolf/EasternWolf.tscn")


func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Default "Escape" action
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Release the mouse
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Recapture the mouse


func initialize_ecosystem():
	# Add 1 plant in every spot in our grid
	for i in range(OhioEcosystemData.grid_size):
		for j in range(OhioEcosystemData.grid_size):
			var plant_quantity = randi_range(3,7)
			for k in range(plant_quantity):
				# Create a new instance of our grass scene.
				var new_plant = grass_scene.instantiate()
				new_plant.set_grid_position(Vector2(i,j))
				new_plant.plant_name = "grass_" + str(OhioEcosystemData.plants_species_data["Grass"]["count"])
				add_child(new_plant)
				# Keep track of population in the global Ohio data
				OhioEcosystemData.plants_species_data["Grass"]["count"] += 1
	
	# Add 5 deer
	for i in range(15):
		var new_deer = deer_scene.instantiate()
		new_deer.set_grid_position(Vector2(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size))
		new_deer.animal_name = "deer_" + str(OhioEcosystemData.animals_species_data["Deer"]["count"])
		add_child(new_deer)
		OhioEcosystemData.animals_species_data["Deer"]["count"] += 1

	# Add 5 rabbits
	for i in range(15):
		var new_rabbit = rabbit_scene.instantiate()
		new_rabbit.set_grid_position(Vector2(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size))
		new_rabbit.animal_name = "rabbit_" + str(OhioEcosystemData.animals_species_data["Rabbit"]["count"])
		add_child(new_rabbit)
		OhioEcosystemData.animals_species_data["Rabbit"]["count"] += 1
	
	# Add 5 wolves
	for i in range(10):
		var new_wolf = wolf_scene.instantiate()
		new_wolf.set_grid_position(Vector2(randi() % OhioEcosystemData.grid_size, randi() % OhioEcosystemData.grid_size))
		new_wolf.animal_name = "wolf_" + str(OhioEcosystemData.animals_species_data["EasternWolf"]["count"])
		add_child(new_wolf)
		OhioEcosystemData.animals_species_data["EasternWolf"]["count"] += 1


func simulate_day():
	print("Day: ", OhioEcosystemData.days)
	get_tree().call_group("plants", "update")
	get_tree().call_group("animals", "update")
	print("End of Day: ", OhioEcosystemData.days)


func start_simulation():
	while OhioEcosystemData.days < 300:
		simulate_day()
		# Wait between days
		await get_tree().create_timer(10.0).timeout
		OhioEcosystemData.days += 1

func _ready():
	randomize()
	initialize_ecosystem()
	start_simulation()
