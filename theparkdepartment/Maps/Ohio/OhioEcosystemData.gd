extends Node


var grid_size: int = 10
var grid_scale: int = 16
var plants = []
var animals = []
var days = 0

var animals_species_data = {
	"Deer": {
		"count": 0,
		"speed": 2,
		"reproduction_cooldown": 10,
		"max_hunger": 20,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 60,
		"nutrition" : 20,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 5,
		"max_social": 10,
	},
	"Rabbit": {
		"count": 0,
		"speed": 3,
		"reproduction_cooldown": 8,
		"max_hunger": 20,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 40,
		"nutrition" : 15,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 2,
		"max_social": 10,
	},
	"EasternWolf": {
		"count": 0,
		"speed": 2,
		"reproduction_cooldown": 15,
		"max_hunger": 16,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 80,
		"nutrition" : 20,
		"diet_type": "Carnivore",
		"prey_organisms": ["Deer", "Rabbit"],
		"population_limit": 100,
		"social_group_size": 5,
		"max_social": 10,
	},
	"AmericanGoldfinch": {
		"count": 0,
		"speed": 2.5,
		"reproduction_cooldown": 10,
		"max_hunger": 20,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 70,
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
		"max_age": 1000,
		"nutrition": 5,
		"cluster_range": 5,
		"max_cluster_neighbors": 10,
		"population_limit": 300,
	}
}
