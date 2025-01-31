extends Node


var grid_size: int = 10
var grid_scale: int = 16
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
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
	},
	"Rabbit": {
		"count": 0,
		"reproduction_cooldown": 8,
		"max_hunger": 5,
		"eye_sight": 3,
		"movement_chance": 1,
		"max_age": 10,
		"nutrition" : 3,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
	},
	"EasternWolf": {
		"count": 0,
		"reproduction_cooldown": 12,
		"max_hunger": 5,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 20,
		"nutrition" : 1,
		"diet_type": "Carnivore",
		"prey_organisms": ["Deer", "Rabbit"],
	}
}

var plants_species_data = {
	"Grass": {
		"count": 0,
		"nutrition": 1,
	}
}
