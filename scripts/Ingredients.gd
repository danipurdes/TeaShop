class_name Ingredients

var ingredient_count_max:int = 5
var ingredient_list:Array[Constants.ingredients] = []
var flavor_profile = FlavorProfile.new([0,0,0,0,0,0])

signal ingredients_changed(new_ingredients:Array[Constants.ingredients])
signal flavors_changed(new_flavors:FlavorProfile)
signal color_changed(new_color:Color)

func _init(new_ingredient_count_max):
	ingredient_count_max = new_ingredient_count_max

func is_valid_ingredient(ingredient:Constants.ingredients):
	return ingredient != Constants.ingredients.NONE

# Modify ingredients
func add_ingredient(new_ingredient:Constants.ingredients):
	return add_ingredient_list([new_ingredient])

func add_ingredient_list(new_ingredient_list:Array[Constants.ingredients]):
	var filtered_list = new_ingredient_list.duplicate(true).filter(is_valid_ingredient)
	if ingredient_list.size() + filtered_list.size() > ingredient_count_max:
		return false
	ingredient_list.append_array(filtered_list)
	update_flavors_and_color(ingredient_list)
	return true

func add_ingredients(new_ingredients:Ingredients):
	if new_ingredients == null:
		return false
	add_ingredient_list(new_ingredients.ingredient_list)

func set_ingredient(new_ingredient:Constants.ingredients):
	return set_ingredient_list([new_ingredient])

func set_ingredient_list(new_ingredient_list:Array[Constants.ingredients]):
	var filtered_list = new_ingredient_list.duplicate(true).filter(is_valid_ingredient)
	if filtered_list.size() > ingredient_count_max:
		return false
	ingredient_list.assign(filtered_list)
	update_flavors_and_color(ingredient_list)
	return true

func set_ingredients(new_ingredients:Ingredients):
	if new_ingredients == null:
		return false
	return set_ingredient_list(new_ingredients.ingredient_list)

func clear_ingredients():
	ingredient_list.clear()
	update_flavors_and_color(ingredient_list)

func transfer_ingredients(target:Ingredients):
	if target.add_ingredient_list(ingredient_list):
		clear_ingredients()
		return true
	return false

# Update derived properties (flavor and color)
func update_flavors_and_color(new_ingredients:Array[Constants.ingredients]):
	var new_flavor_profile:FlavorProfile = calculate_flavor_profile(new_ingredients)
	flavor_profile = new_flavor_profile
	flavors_changed.emit(new_flavor_profile)

	color_changed.emit(calculate_color(new_ingredients))

func calculate_flavor_profile(new_ingredients:Array[Constants.ingredients]):
	var new_flavor_profile:FlavorProfile = FlavorProfile.new([0,0,0,0,0,0])
	for ingredient in new_ingredients:
		new_flavor_profile.add_ingredient(ingredient)
	return new_flavor_profile

func calculate_color(new_ingredients:Array[Constants.ingredients]):
	if new_ingredients.size() == 0:
		return Color(0,0,0,0)
	
	var color_list = []
	for ingredient in ingredient_list:
		color_list.append(Constants.ingredientColorMap[ingredient])
	return ColorUtility.BlendColorList(color_list)

# Utility functions
func ingredients_to_string():
	var ingredientMap = {}
	for ingredient in ingredient_list:
		if ingredientMap.has(ingredient):
			ingredientMap[ingredient] = ingredientMap[ingredient] + 1
		else:
			ingredientMap[ingredient] = 1
	
	var output = ""
	var ingredient_names = Constants.ingredients.keys()
	for ingredient in ingredientMap:
		output += ingredient_names[ingredient]
		output += (" x" + str(ingredientMap[ingredient])) if ingredientMap[ingredient] > 1 else ""
		output += "\n"
	if ingredient_list.size() > 0:
		output = output.substr(0, output.length() - 1)
	return output
