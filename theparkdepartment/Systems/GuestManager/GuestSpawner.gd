extends Path3D

@onready var spawn_point := $PathFollow3D
@onready var timer := $GuestSpawnTimer

const GUEST_SCENE_PATH := "res://Systems/GuestManager/Guest.tscn"
var guest_scene: PackedScene


func _ready():
	guest_scene = load(GUEST_SCENE_PATH)
	if not guest_scene:
		push_error("Guest Manager: Failed to load guest scene at: " + GUEST_SCENE_PATH)
		return
	
	timer.timeout.connect(_on_timer_timeout)
	_set_random_timer()
	
	# Spawn 10 initial guests at increments along the path
	spawn_initial_guests()


func _on_timer_timeout():
	spawn_guest()
	_set_random_timer()


func _set_random_timer():
	timer.wait_time = randf_range(4, 15)
	timer.start()


func spawn_guest():
	if not guest_scene:
		print("Guest Manager: No guest scene assigned!")
		return

	var guest = guest_scene.instantiate()

	# Reset guest transform to PathFollow's transform
	guest.global_transform = spawn_point.global_transform

	# Tell the guest to follow this path
	guest.set("path", self)

	add_child(guest)  # Adds to the Path3D node


# Function to spawn the initial 10 guests
func spawn_initial_guests():
	for i in range(10):
		var guest = guest_scene.instantiate()

		# Set the guest's distance along the path
		var distance = (i + 1) * 40  # This will give distances from 40 to 480

		guest.distance = distance

		# Tell the guest to follow the path
		guest.set("path", self)

		add_child(guest)  # Adds the guest to the Path3D node
