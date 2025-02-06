extends Node


var grid_size: int = 10
var grid_scale: int = 16
var plants = []
var animals = []
var days = 0

var animals_species_data = {
	"Deer": {
		"count": 0,
		"reproduction_cooldown": 4,
		"max_hunger": 10,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 15,
		"nutrition" : 10,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 5,
		"max_social": 10,
	},
	"Rabbit": {
		"count": 0,
		"reproduction_cooldown": 3,
		"max_hunger": 10,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 10,
		"nutrition" : 7,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 2,
		"max_social": 10,
	},
	"EasternWolf": {
		"count": 0,
		"reproduction_cooldown": 6,
		"max_hunger": 8,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 20,
		"nutrition" : 6,
		"diet_type": "Carnivore",
		"prey_organisms": ["Deer", "Rabbit"],
		"population_limit": 100,
		"social_group_size": 5,
		"max_social": 10,
	},
	"AmericanGoldfinch": {
		"count": 0,
		"reproduction_cooldown": 3,
		"max_hunger": 10,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 10,
		"nutrition" : 7,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 2,
		"max_social": 10,
	},
}

var plants_species_data = {
	"Grass": {
		"count": 0,
		"reproduction_cooldown": 2,
		"max_age": 15,
		"nutrition": 5,
		"cluster_range": 5,
		"max_cluster_neighbors": 30,
		"population_limit": 1000,
	}
}
