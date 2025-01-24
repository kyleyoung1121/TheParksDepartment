extends Node


var grid_size: int = 10
var plants = []
var animals = []
var days = 0

var animals_species_data = {
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
}

var plant_species_data = {
	"Grass": {
		"count": 0
	}
}
