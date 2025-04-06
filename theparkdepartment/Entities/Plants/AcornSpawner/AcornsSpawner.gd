extends Node3D

@export var spawn_rate := 10  # Seconds between spawns
@export var crowd_max := 6    # Max number of acorns allowed at once

var acorn_scene := preload("res://Entities/Plants/AcornSpawner/Acorn.tscn")
var spawned_acorns := []

@onready var spawn_timer: Timer = $SpawnTimer


func _ready():
	spawn_timer.wait_time = spawn_rate * randf_range(0.8, 1.2)
	spawn_timer.start()


func _on_spawn_timer_timeout():
	# Clean up any freed acorns
	spawned_acorns = spawned_acorns.filter(func(acorn): return is_instance_valid(acorn))

	if spawned_acorns.size() >= crowd_max:
		return  # Too many acorns already

	var acorn = acorn_scene.instantiate()
	acorn.position += get_random_offset()
	acorn.rotation.y += randf_range(0,PI*2)
	add_child(acorn)
	spawned_acorns.append(acorn)
	
	spawn_timer.wait_time *= randf_range(0.8, 1.2)


func get_random_offset() -> Vector3:
	var angle = randf_range(0, TAU) # Random angle around the Y axis
	var direction = Vector3(cos(angle), 0, sin(angle)).normalized()

	var distance = randf_range(4.0, 10.0) # Distance from trunk, at least 2m
	return direction * distance
