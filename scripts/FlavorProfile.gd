class_name FlavorProfile

var flavors:Array[int] = [0, 0, 0, 0, 0, 0]

func _init(flavor_array:Array[int]):
	add_flavor_list(flavor_array)

# Modify flavors
func add_ingredient(ingredient:Constants.ingredients):
	return add_flavor_list(Constants.ingredientFlavorMap[ingredient])

func add_ingredient_list(new_ingredient_list:Array[Constants.ingredients]):
	for ingredient in new_ingredient_list:
		if !add_ingredient(ingredient):
			return false
	return true

func add_flavor_list(new_flavor_list:Array):
	if new_flavor_list == null or new_flavor_list.size() != flavors.size():
		print_debug("addFlavorArray: flavorArray null or size mismatch")
		return false
	for flavor_index in new_flavor_list.size():
		flavors[flavor_index] += new_flavor_list[flavor_index]
	return true

func add_flavor_profile(new_flavor_profile:FlavorProfile):
	if new_flavor_profile == null:
		return false
	return add_flavor_list(new_flavor_profile.flavors)

func set_flavor(new_flavor:Constants.ingredients):
	set_flavor_list([new_flavor])

func set_flavor_list(new_flavor_list:Array[int]):
	if new_flavor_list == null or new_flavor_list.size() != flavors.size():
		return false
	flavors.assign(new_flavor_list)
	return true

func set_flavor_profile(new_flavor_profile:FlavorProfile):
	if new_flavor_profile == null:
		return false
	return set_flavor_list(new_flavor_profile.flavors)

func clear_flavor_profile():
	flavors.resize(6)
	flavors.fill(0)

# Utility functions
func get_flavor_magnitude():
	return compare_flavor_lists([0, 0, 0, 0, 0, 0])

func compare_flavor_lists(flavor_list):
	if flavor_list == null or flavor_list.size() != flavors.size():
		print_debug("compareFlavorProfiles: flavorArray null or size mismatch")
		return -1
	
	var total_delta = 0
	for index in flavors.size():
		var flavor_diff = absi(flavor_list[index] - flavors[index])
		total_delta += flavor_diff
	return total_delta

func to_amount_string():
	var output = ""
	for flavor_index in flavors.size():
		for n in flavors[flavor_index]:
			output += str(flavor_index)
	return output

func to_stacked_string():
	var output = ""
	for flavor_index in flavors.size():
		for n in flavors[flavor_index]:
			output += str(flavor_index)
		if flavors[flavor_index] > 0:
			output += "\n"
	output = output.trim_suffix("\n")
	return output