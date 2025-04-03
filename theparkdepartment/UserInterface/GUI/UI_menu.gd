extends Control

signal start_object_placement(structure_type)

# ANIMAL STATS
var tracking = false
var index

# CLOCK
var meridiem
var clock = 288 # 4:48 AM
var day = 1;
var mult = 1;
var check = 0;

var DeerCount
var RabbitCount
var EasternWolfCount
var CoyoteCount
var AmericanGoldfinchCount
var CoopersHawkCount
var PlantCount

# Object Prices
var fence_cost = 25 
var log_cabin_cost = 125
var watchtower_cost = 150
var tree_cost = 10
var bathroom_cost = 50

#Object Determination
var selected_object = ""

func _process(delta: float) -> void:
	#for i in animalStats:
		#i.hunger = i.hunger - 0.025
		#i.thirst = i.thirst - 0.025
	
	#if (tracking == true && index != null):
		#$HungerBar.value = animalStats[index].hunger
		#$ThirstBar.value = animalStats[index].thirst
	$Panel2/Funds.text = "$" + str(OhioEcosystemData.funds)
	
	if ($Panel/ListHeader.text == "Animal Count"):
		$Panel/ScrollContainer/VBoxContainer/ListItem1.text = "White Tailed Deer: " + str(OhioEcosystemData.animals_species_data["Deer"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem2.text = "Rabbit: " + str(OhioEcosystemData.animals_species_data["Rabbit"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem3.text = "Eastern Wolf: " + str(OhioEcosystemData.animals_species_data["EasternWolf"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem4.text = "Coyote: " +  str(OhioEcosystemData.animals_species_data["Coyote"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem5.text = "American Goldfinch: " + str(OhioEcosystemData.animals_species_data["AmericanGoldfinch"]["count"])
		$Panel/ScrollContainer/VBoxContainer/ListItem6.text = "Cooper's Hawk: " + str(OhioEcosystemData.animals_species_data["CoopersHawk"]["count"])
	elif ($Panel/ListHeader.text == "Plant Count"):
		$Panel/ScrollContainer/VBoxContainer/ListItem1.text = "Grass: " + str(OhioEcosystemData.plants_species_data["Grass"]["count"])
	
	if (check == 20):
		clock = clock + mult;
		check = 0
	check = check + 1
	
	if (clock == 1440):
		clock = 0
		day += 1
		$DayCount.text = "Day " + str(day)
	elif (clock >= 1440):
		clock = 0
		print("Color Error")
	
	var hour = floor(clock / 60)
	var minutes = clock - (hour * 60)
	if (minutes < 10):
		minutes = "0" + str(minutes)
		
	if (clock > 720):
		meridiem = "pm";
	else:
		meridiem = "am";
	
	$Clock.text = str(hour) + ":" + str(minutes) + meridiem

func _ready() -> void:
	$BuildMenu/FencePrice.add_theme_color_override("bg_color", Color.WEB_GREEN)
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
	selected_object = "Fence"
	emit_signal("start_object_placement", selected_object)
	building_check()


func _on_place_cabin_button_pressed():
	selected_object = "Log Cabin"
	emit_signal("start_object_placement", selected_object)
	building_check()


func _on_place_watchtower_button_pressed():
	selected_object = "Watchtower"
	emit_signal("start_object_placement", selected_object)
	building_check()


func _on_place_trees_button_pressed():
	selected_object = "Trees"
	emit_signal("start_object_placement", selected_object)
	building_check()


func _on_place_bathroom_button_pressed():
	selected_object = "Bathroom"
	emit_signal("start_object_placement", selected_object)
	building_check()


func building_check() -> void:
	if (selected_object == "Fence"):
		$BuildConfirmation/BuildCost.text = "Cost: $25"
	elif (selected_object == "Log Cabin"):
		$BuildConfirmation/BuildCost.text = "Cost: $125"
	elif (selected_object == "Watchtower"):
		$BuildConfirmation/BuildCost.text = "Cost: $150"
	elif (selected_object == "Trees"):
		$BuildConfirmation/BuildCost.text = "Cost: $10"
	elif (selected_object == "Bathroom"):
		$BuildConfirmation/BuildCost.text = "Cost: $50"
	
	$BuildConfirmation.visible = true


func _on_fast_forward_button_pressed() -> void:
	OhioEcosystemData.speedMult = 0.2
func _on_play_button_pressed() -> void:
	OhioEcosystemData.speedMult = 0.1
func _on_pause_button_pressed() -> void:
	OhioEcosystemData.speedMult = 0


func _on_animal_status_button_pressed() -> void:
	if ($BuildMenu.visible == true):
		$BuildMenu.visible = false
	if ($Panel.visible == true and $Panel/ListHeader.text == "Animal Count"):
		$Panel.visible = false
	elif ($Panel/ListHeader.text == "Plant Count" and $Panel.visible == true):
		$Panel.visible = true
	else:
		$Panel.visible = true
		
	$Panel/ListHeader.text = "Animal Count"
	$Panel/ScrollContainer/VBoxContainer/ListItem1.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem2.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem3.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem4.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem5.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem6.visible = true

func _on_plant_status_button_pressed() -> void:
	if ($BuildMenu.visible == true):
		$BuildMenu.visible = false
	if ($Panel.visible == true and $Panel/ListHeader.text == "Plant Count"):
		$Panel.visible = false
	elif ($Panel/ListHeader.text == "Animal Count" and $Panel.visible == true):
		$Panel.visible = true
	else:
		$Panel.visible = true
	
	$Panel/ListHeader.text = "Plant Count"
	$Panel/ScrollContainer/VBoxContainer/ListItem1.visible = true
	$Panel/ScrollContainer/VBoxContainer/ListItem2.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem3.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem4.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem5.visible = false
	$Panel/ScrollContainer/VBoxContainer/ListItem6.visible = false


func _on_exit_menu_pressed() -> void:
	$Panel.visible = false


func _on_building_button_pressed() -> void:
	if ($Panel.visible == true):
		$Panel.visible = false
	
	$BuildMenu.visible = true


func _on_exit_menu_2_pressed() -> void:
	$BuildMenu.visible = false


func _on_cofirm_build_pressed() -> void:
	pass # Place the Selected Object

func _on_cancel_build_pressed() -> void:
	$BuildConfirmation.visible = false
	selected_object = ""
