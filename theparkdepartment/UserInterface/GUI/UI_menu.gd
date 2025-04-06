extends Control

signal start_object_placement(structure_type)
signal confirm_object_placement()
signal cancel_object_placement()

# Timer reference
@onready var clock_timer = $ClockTimer

# Object Prices
var building_prices = {
	"Fence": 25,
	"Cabin": 125,
	"Watchtower": 150,
	"Trees": 10,
	"Bathroom": 50,
	"Research Center": 100,
}

# Animal Prices
var animal_prices = {
	"AmericanGoldfinch": 25,
	"CoopersHawk": 75,
	"Coyote": 75,
	"Deer": 50,
	"EasternWolf": 75,
	"Rabbit": 25,
	"BlackVulture": 50,
	"TurkeyVulture": 50,
}

# ANIMAL STATS
var tracking = false
var index

# CLOCK
const DAY_LENGTH_SECONDS := 240.0  # Real seconds per in-game day (4 minutes)
var clock := 480 # Start the game at 8:00 am
var day := 1

# ANIMAL COUNTS
var DeerCount
var RabbitCount
var EasternWolfCount
var CoyoteCount
var AmericanGoldfinchCount
var CoopersHawkCount
var PlantCount

# RNG
var rng = RandomNumberGenerator.new()

# Object Determination
var selected_object = ""
var selected_object_type = ""

# Script reference
var object_placement
var animal_placement

var animal_facts = {
	"1": {
		"name": "White-tailed Deer",
		"image": "res://UserInterface/GUI/Animal Images/deer.png",
		"facts" : {
			"1": "Baby white-tailed deer, called fawns, are born with spots that help them camouflage with their surroundings, making it difficult for predators to spot them.",
			"2": "White-tailed deer have a four-chambered stomach, which allows them to digest a wide variety of vegetation, including thorny plants and even some poisonous mushrooms.",
			"3": "White-tailed deer communicate through a variety of sounds, including snorts, bleats, and grunts, and they also use their tails to signal danger by 'flagging.'"
		}
	},
	"2": {
		"name": "Eastern Wolf",
		"image": "res://UserInterface/GUI/Animal Images/wolf.png",
		"facts" : {
			"1": "They are a hybrid species, with genetic evidence suggesting they are about 58% gray wolf and 42% coyote.",
			"2": "They use a variety of vocalizations, body language, and scent marking to communicate within their packs.",
			"3": "They are found in deciduous and mixed forest landscapes, often near water sources and in areas with abundant prey like white-tailed deer and moose."
		}
	},
	"3": {
		"name": "Coyote",
		"image": "res://UserInterface/GUI/Animal Images/coyote.png",
		"facts" : {
			"1": "Coyotes are not strictly nocturnal; they are crepuscular, meaning they are most active during dawn and dusk, but can be active at any time of the day or night.",
			"2": "Coyotes use a wide array of vocalizations, including howls, yips, barks, and growls, to communicate with each other and warn of danger.",
			"3": "Coyotes can run up to 40 miles per hour, making them one of the fastest land mammals in North America."
		}
	},
	"4": {
		"name": "Eastern Cottontail Rabbit",
		"image": "res://UserInterface/GUI/Animal Images/rabbit.png",
		"facts" : {
			"1": "They are herbivores and eat a variety of plants, including grasses, clovers, alfalfa, plantain, and dandelions.",
			"2": "They prefer areas with dense shrubs for protection and open areas with green grasses and herbs for foraging.",
			"3": "They use speed and caution to avoid predators, and can reach speeds of up to 18 mph when running."
		}
	},
	"5": {
		"name": "Goldfinch",
		"image": "res://UserInterface/GUI/Animal Images/goldfinch.png",
		"facts" : {
			"1": "Goldfinches are almost exclusively vegetarians, primarily feeding on seeds, especially those of the daisy family.",
			"2": "They are unique among finches in molting their feathers twice a year, once in late winter/early spring and again in late summer/early fall.",
			"3": "Paired-up goldfinches make virtually identical flight calls, which may help them distinguish members of their pair."
		}
	},
	"6": {
		"name": "Coopers Hawk",
		"image": "res://UserInterface/GUI/Animal Images/hawk.png",
		"facts" : {
			"1": "Cooper's hawks are stealthy hunters, often ambushing prey from perches or moving quietly through dense cover before launching a quick attack.",
			"2": "They have short, powerful wings and a long tail, which allows them to be highly maneuverable in dense forest habitats.",
			"3": "Female Cooper's Hawks are about 30% larger than their male counterparts."
		}
	},
	"7": {
		"name": "Black Vulture",
		"image": "res://UserInterface/GUI/Animal Images/BlackVulture.png",
		"facts" : {
			"1": "Black vultures usually feed together in large groups, and are so aggressive that other vulture species will stay away.",
			"2": "Both the male and female parents take turns incubating their eggs.",
			"3": "Black vulture mating pairs may remain together and reuse a successful nesting site for many years."
		}
	},
	"8": {
		"name": "Turkey Vulture",
		"image": "res://UserInterface/GUI/Animal Images/TurkeyVulture.png",
		"facts" : {
			"1": "Turkey vultures are primarily scavengers, playing a crucial role in the ecosystem by consuming carrion and preventing the spread of disease.",
			"2": "Their keen sense of smell is one of the most remarkable adaptations, enabling them to locate food from miles away.",
			"3": "They are known for their graceful soaring flight, using thermals to conserve energy and travel long distances."
		}
	}
}


func _process(delta: float) -> void:
	# Update funds and release count display
	$Panel2/Funds.text = "$" + str(OhioEcosystemData.funds)
	$Panel3/ReleaseCount.text = str(OhioEcosystemData.release_count)

	# Update list depending on header
	if $Panel/ListHeader.text == "Animal Count":
		var animal_data = OhioEcosystemData.animals_species_data
		$Panel/ScrollContainer/VBoxContainer/ListItem1.text = "White Tailed Deer: " + str(animal_data["Deer"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem2.text = "Rabbit: " + str(animal_data["Rabbit"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem3.text = "Eastern Wolf: " + str(animal_data["EasternWolf"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem4.text = "Coyote: " + str(animal_data["Coyote"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem5.text = "American Goldfinch: " + str(animal_data["AmericanGoldfinch"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem6.text = "Cooper's Hawk: " + str(animal_data["CoopersHawk"]["count"])
	elif $Panel/ListHeader.text == "Plant Count":
		var plant_data = OhioEcosystemData.plants_species_data
		$Panel/ScrollContainer/VBoxContainer/ListItem1.text = "Grass: " + str(plant_data["Grass"]["count"])


func _ready() -> void:
	$BuildMenu/BuildingOptions/VBoxContainer/HBoxContainer2/TreesButton/TreesPrice.add_theme_color_override("bg_color", Color.WEB_GREEN)
	
	# Get reference to parent (main scene) and find ObjectPlacement child node
	var parent = get_parent()
	object_placement = parent.get_node("ObjectPlacement")
	animal_placement = parent.get_node("AnimalPlacement")
	
	#var menu = get_node("MenuButton")
	#menu.get_popup().add_item("Deer")
	#menu.get_popup().add_item("Wolf")
	#menu.get_popup().add_item("Bird")
	#menu.get_popup().add_item("Fox")
	#menu.get_popup().add_item("Squirrel")
	#menu.get_popup().id_pressed.connect(_on_item_menu_pressed)

#func _on_item_menu_pressed(id: int):
	#$HungerBar.visible = true;
	#$ThirstBar.visible = true;
	#
	#if (id == 0): # Deer
		#$HungerBar.value = animalStats[0].hunger
		#$ThirstBar.value = animalStats[0].thirst
	#elif (id == 1): # Wolf
		#$HungerBar.value = animalStats[1].hunger
		#$ThirstBar.value = animalStats[1].thirst
	#elif (id == 2): # Bird
		#$HungerBar.value = animalStats[2].hunger
		#$ThirstBar.value = animalStats[2].thirst
	#elif (id == 3): # Fox
		#$HungerBar.value = animalStats[3].hunger
		#$ThirstBar.value = animalStats[3].thirst
	#elif (id == 4): # Squirrel
		#$HungerBar.value = animalStats[4].hunger
		#$ThirstBar.value = animalStats[4].thirst
	#index = id
	#tracking = true;


func _on_place_fence_button_pressed():
	if OhioEcosystemData.funds >= building_prices["Fence"]:
		object_placement.start_placing("Fence")


func _on_place_cabin_button_pressed():
	if OhioEcosystemData.funds >= building_prices["Cabin"]:
		object_placement.start_placing("Cabin")


func _on_place_watchtower_button_pressed():
	if OhioEcosystemData.funds >= building_prices["Watchtower"]:
		object_placement.start_placing("Watchtower")


func _on_place_trees_button_pressed():
	if OhioEcosystemData.funds >= building_prices["Trees"]:
		object_placement.start_placing("Trees")


func _on_place_bathroom_button_pressed():
	if OhioEcosystemData.funds >= building_prices["Bathroom"]:
		object_placement.start_placing("Bathroom")


func _on_place_research_center_button_pressed():
	if OhioEcosystemData.funds >= building_prices["Research Center"]:
		object_placement.start_placing("Research Center")


func _on_deer_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["Deer"]:
			animal_placement.start_placing("Deer")


func _on_wolf_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["EasternWolf"]:
			animal_placement.start_placing("EasternWolf")


func _on_coyote_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["Coyote"]:
			animal_placement.start_placing("Coyote")


func _on_rabbit_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["Rabbit"]:
			animal_placement.start_placing("Rabbit")


func _on_goldfinch_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["AmericanGoldfinch"]:
			animal_placement.start_placing("AmericanGoldfinch")


func _on_coopers_hawk_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["CoopersHawk"]:
			animal_placement.start_placing("CoopersHawk")


func _on_black_vulture_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["BlackVulture"]:
			animal_placement.start_placing("BlackVulture")


func _on_turkey_vulture_button_pressed():
	if OhioEcosystemData.release_count >= 1:
		if OhioEcosystemData.funds >= animal_prices["TurkeyVulture"]:
			animal_placement.start_placing("TurkeyVulture")


func placement_requested(type, selection) -> void:
	selected_object = selection
	selected_object_type = type
	
	if (type == "Object"):
		var building_cost = building_prices[selection]
		$BuildConfirmation/BuildCost.text = "Cost: $" + str(building_cost)
		$BuildConfirmation.visible = true
	
	if (type == "Animal"):
		var animal_cost = animal_prices[selection]
		$BuildConfirmation/BuildCost.text = "Cost: $" + str(animal_cost)
		$BuildConfirmation.visible = true


func _on_fast_forward_button_pressed() -> void:
	Engine.time_scale = 5


func _on_play_button_pressed() -> void:
	Engine.time_scale = 1


func _on_pause_button_pressed() -> void:
	Engine.time_scale = 0.0001


func _on_animal_status_button_pressed() -> void:
	if ($BuildMenu.visible == true):
		$BuildMenu.visible = false
	if ($Panel.visible == true and $Panel/ListHeader.text == "Animal Count"):
		$Panel.visible = false
		return
	
	$Panel.size = Vector2(287, 269)
	$Panel.position.y = 806
	$Panel/ListHeader.text = "Animal Count"
	$Panel/ScrollContainer/VBoxContainer/ListItem1.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem2.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem3.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem4.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem5.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem6.visible = true
	$Panel.visible = true


func _on_plant_status_button_pressed() -> void:
	if ($BuildMenu.visible == true):
		$BuildMenu.visible = false
	if ($Panel.visible == true and ($Panel/ListHeader.text == "Plant Count")):
		$Panel.visible = false
		return
	
	$Panel.size = Vector2(287, 104)
	$Panel.position.y = 971
	$Panel/ListHeader.text = "Plant Count"
	$Panel/ScrollContainer/VBoxContainer/ListItem1.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem2.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem3.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem4.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem5.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem6.visible = false
	$Panel.visible = true


func _on_exit_menu_pressed() -> void:
	$Panel.visible = false


func _on_building_button_pressed() -> void:
	if ($Panel.visible == true):
		$Panel.visible = false
	if ($BuildMenu.visible == true and $BuildMenu/BuildMenuLabel.text == "Building"):
		$BuildMenu.visible = false
		return
	
	$BuildMenu/BuildMenuLabel.text = "Building"
	$BuildMenu/AnimalOptions.visible = false
	$BuildMenu/BuildingOptions.visible = true
	$BuildMenu.visible = true


func _on_releasing_button_pressed() -> void:
	if ($Panel.visible == true):
		$Panel.visible = false
	if ($BuildMenu.visible == true and $BuildMenu/BuildMenuLabel.text == "Release an animal"):
		$BuildMenu.visible = false
		return
	
	$BuildMenu/BuildMenuLabel.text = "Release an animal"
	$BuildMenu/BuildingOptions.visible = false
	$BuildMenu/AnimalOptions.visible = true
	$BuildMenu.visible = true


func _on_exit_menu_2_pressed() -> void:
	$BuildMenu.visible = false


func _on_confirm_build_pressed() -> void:
	if selected_object_type == "Object":
		if OhioEcosystemData.funds >= building_prices[selected_object]:
			OhioEcosystemData.funds -= building_prices[selected_object]
			$BuildConfirmation.visible = false
			object_placement.confirm_placement()
			selected_object = ""
	
	elif selected_object_type == "Animal":
		if OhioEcosystemData.funds >= animal_prices[selected_object]:
			OhioEcosystemData.funds -= animal_prices[selected_object]
			$BuildConfirmation.visible = false
			animal_placement.confirm_placement()
			selected_object = ""


func _on_cancel_build_pressed() -> void:
	if selected_object_type == "Object":
		$BuildConfirmation.visible = false
		object_placement.cancel_placement()
		selected_object = ""
	
	elif selected_object_type == "Animal":
		$BuildConfirmation.visible = false
		animal_placement.cancel_placement()
		selected_object = ""


func _on_bulldozer_button_pressed() -> void:
	selected_object = "" # not sure how to wait for the user to select an object
	
	$BuildConfirmation/Label.text = "Click the checkbox to delete the selected build!"
	if (selected_object == "Fence"):
		$BuildConfirmation/BuildCost.text = "Refund: $20"
	elif (selected_object== "Cabin"):
		$BuildConfirmation/BuildCost.text = "Refund: $100"
	elif (selected_object == "Watchtower"):
		$BuildConfirmation/BuildCost.text = "Cost: $120"
	elif (selected_object == "Trees"):
		$BuildConfirmation/BuildCost.text = "Cost: $10"
	elif (selected_object == "Bathroom"):
		$BuildConfirmation/BuildCost.text = "Cost: $40"


func _on_facts_button_pressed() -> void:
	$"Random Facts".visible = true
	var animal_selection = round(rng.randf_range(0.5, len(animal_facts)+0.49))
	var fact_selection = round(rng.randf_range(0.5, len(animal_facts[str(animal_selection)]["facts"])+0.49))
	
	var full_fact = animal_facts[str(animal_selection)]["facts"][str(fact_selection)]
	var fact = ""
	for i in range(len(full_fact)-1):
		if i <= 80:
			if (i % 16 == 0) and i != 0:
				if (full_fact[i] != " " and full_fact[i] != "," and full_fact[i] != ";"):
					if full_fact[i] == " ":
						print("SPACE")
					if (full_fact[i-1] == " "):
						fact += "\n" + full_fact[i]
						print(full_fact[i], " letter but previous letter space")
					else: 
						fact += "-\n" + full_fact[i]
						print(full_fact[i], " letter standard dash")
				else:
					if (full_fact[i] != " "):
						fact += "\n" + full_fact[i]
						print(full_fact[i], " comma or semi col")
					else:
						i+=1
						fact += "\n" + full_fact[i]
						print(full_fact[i], " space!!")
			else:
				fact += full_fact[i]
		else:
			if ((i-80)% 31 == 0) and i != 0:
				if (full_fact[i] != " " and full_fact[i] != "," and full_fact[i] != ";"):
					if full_fact[i] == " ":
						print("SPACE")
					if (full_fact[i-1] == " "):
						fact += "\n" + full_fact[i]
						print(full_fact[i], " letter but previous letter space")
					else: 
						fact += "-\n" + full_fact[i]
						print(full_fact[i], " letter standard dash")
				else:
					if (full_fact[i] != " "):
						fact += "\n" + full_fact[i]
						print(full_fact[i], " comma or semi col")
					else:
						i+=1
						fact += "\n" + full_fact[i]
						print(full_fact[i], " space!!")
			else:
				fact += full_fact[i]
	#
	$"Random Facts/Photo".texture = load(animal_facts[str(animal_selection)]["image"])
	$"Random Facts/Header".text = animal_facts[str(animal_selection)]["name"]
	$"Random Facts/Fact".text = fact


func _on_exit_menu_3_pressed() -> void:
	$"Random Facts".visible = false


func _on_clock_timer_timeout():
	# Update in-game time by adding 6 minutes every second
	clock += 30

	if clock >= 1440.0:  # A full day (24 hours * 60 minutes)
		clock -= 1440.0  # Reset the clock after a full day
		day += 1
		OhioEcosystemData.release_count = OhioEcosystemData.release_count_max
		$DayCount/Label.text = "Day " + str(day)

	# Format time
	var hour := int(clock) / 60
	var minutes := int(clock) % 60
	var meridiem := "pm" if hour >= 12 else "am"

	hour %= 12
	if hour == 0:
		hour = 12

	var minutes_str := str(minutes).pad_zeros(2)
	$Clock/Label.text = str(hour) + ":" + minutes_str + meridiem
