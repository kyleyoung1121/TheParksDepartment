extends Node

var score := 0.0

func _ready():
	# Create and configure the timer
	var timer = Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = false
	timer.autostart = true
	
	# Add it to the scene and connect the signal
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	grade_ecosystem()


func grade_ecosystem():
	var animal_data = OhioEcosystemData.animals_species_data
	
	# Get population counts
	var populations = []
	for species_name in animal_data.keys():
		var count = animal_data[species_name].get("count", 0)
		populations.append(count)
	
	score = get_shannon_diversity_index(populations)
	print("Ecosystem - Final Ecosystem Health Score: ", score)
	OhioEcosystemData.ecosystem_multiplier = score


func get_shannon_diversity_index(populations: Array) -> float:
	var total = 0
	for count in populations:
		total += count

	if total == 0:
		return 0.0
	
	var H = 0.0
	for count in populations:
		if count > 0:
			var p = float(count) / total
			H -= p * log(p)

	print("Ecosystem - Raw Shannon Index H: ", H)
	
	# Calculate the multiplier based on H (scale it from 1x to 5x)
	var species_count = populations.filter(func(p): return p > 0).size()

	# If there is only 1 or no species, return a multiplier of 1
	if species_count <= 1:
		return 1.0
	
	# Calculate multiplier based on H (using the scaling formula)
	var multiplier = scale_shannon_to_multiplier(H)
	
	return multiplier


# Function to scale Shannon Index (H) to the desired multiplier range
func scale_shannon_to_multiplier(H: float) -> float:
	# Define the min and max H values
	var min_H = 0.85
	var max_H = 1.79
	
	# Define the min and max multipliers
	var min_multiplier = 1.0
	var max_multiplier = 5.0
	
	# If H is below the minimum, set multiplier to min_multiplier
	if H < min_H:
		return min_multiplier
	# If H is above the maximum, set multiplier to max_multiplier
	elif H > max_H:
		return max_multiplier
	# Otherwise, scale H to the multiplier range
	else:
		return min_multiplier + ((H - min_H) / (max_H - min_H)) * (max_multiplier - min_multiplier)
