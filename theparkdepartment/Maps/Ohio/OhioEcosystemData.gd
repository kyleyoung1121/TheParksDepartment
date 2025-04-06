extends Node


var grid_size: int = 10
var grid_scale: int = 16
var plants = []
var animals = []
#var days = 1
var cycle_count = 0
var funds = 450
var release_count = 5
var release_count_max = 5

var animals_species_data = {
	"Deer": {
		"count": 0,
		"speed": 1.5,
		"max_stamina": 5,
		"reproduction_cooldown": 30,
		"max_hunger": 30,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 110,
		"nutrition": 40,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 5,
		"max_social": 10,
		"litter_size": 2,
	},
	"Rabbit": {
		"count": 0,
		"speed": 2.5,
		"max_stamina": 5,
		"reproduction_cooldown": 25,
		"max_hunger": 30,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 90,
		"nutrition": 35,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 6,
		"max_social": 10,
		"litter_size": 2,
	},
	"Squirrel": {
		"count": 0,
		"speed": 2.5,
		"max_stamina": 5,
		"reproduction_cooldown": 25,
		"max_hunger": 30,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 70,
		"nutrition": 35,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass", "Acorn"],
		"population_limit": 100,
		"social_group_size": 6,
		"max_social": 10,
		"litter_size": 2,
	},
	"EasternWolf": {
		"count": 0,
		"speed": 1.5,
		"max_stamina": 5,
		"reproduction_cooldown": 40,
		"max_hunger": 80,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 120,
		"nutrition": 30,
		"diet_type": "Carnivore",
		"prey_organisms": ["Deer", "Rabbit", "Coyote", "Squirrel"],
		"population_limit": 30,
		"social_group_size": 10,
		"max_social": 10,
		"litter_size": 2,
	},
	"Coyote": {
		"count": 0,
		"speed": 2,
		"max_stamina": 5,
		"reproduction_cooldown": 40,
		"max_hunger": 80,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 120,
		"nutrition": 30,
		"diet_type": "Carnivore",
		"prey_organisms": ["Rabbit", "Squirrel"],
		"population_limit": 30,
		"social_group_size": 10,
		"max_social": 10,
		"litter_size": 2,
	},
	"AmericanGoldfinch": {
		"count": 0,
		"speed": 2,
		"max_stamina": 5,
		"reproduction_cooldown": 40,
		"max_hunger": 40,
		"eye_sight": 6,
		"movement_chance": 1,
		"max_age": 70,
		"nutrition": 50,
		"diet_type": "Herbivore",
		"prey_organisms": ["Grass"],
		"population_limit": 100,
		"social_group_size": 100,
		"max_social": 10,
		"litter_size": 2,
	},
	"CoopersHawk": {
		"count": 0,
		"speed": 1.5,
		"max_stamina": 5,
		"reproduction_cooldown": 40,
		"max_hunger": 80,
		"eye_sight": 8,
		"movement_chance": 1,
		"max_age": 120,
		"nutrition": 30,
		"diet_type": "Carnivore",
		"prey_organisms": ["AmericanGoldfinch", "Rabbit", "Squirrel"],
		"population_limit": 30,
		"social_group_size": 10,
		"max_social": 10,
		"litter_size": 2,
	}
}

var plants_species_data = {
	"Grass": {
		"count": 0,
		"reproduction_cooldown": 12,
		"max_age": 120,
		"nutrition": 15,
		"cluster_range": 10,
		"max_cluster_neighbors": 10,
		"population_limit": 800,
		"extra_resilience": 0.6,
	},
	
	"Acorn": {
		"nutrition": 15,
	}
}

# 2D array for fences (starting and ending points) 
var fences = [
	[
		Vector3(50, 0, 0), Vector3(50, 0, 25)
	],
	[
		Vector3(50, 0, 25), Vector3(75, 0, 25)
	],
	[
		Vector3(75, 0, 25), Vector3(75, 0, 0)
	],
	[
		Vector3(75, 0, 0), Vector3(50, 0, 0)
	],
]
