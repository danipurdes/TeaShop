class_name Ingredients

@export var max_ingredients = 5

var ingredients = []
var flavor_profile = FlavorProfile.new([0,0,0,0,0,0])
var ingredientsColor = Constants.ingredientColorMap[Constants.ingredients.NONE]
var ingredientsMat = StandardMaterial3D.new()

signal ingredients_changed(newIngredients)
signal flavors_changed(newFlavors)

func _init():
	ingredientsMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	calculateMaterial()

func addIngredient(ingredient):
	if ingredient == Constants.ingredients.NONE:
		print_debug("Tried adding NONE ingredient")
		return false
	if ingredients.size() == max_ingredients:
		print_debug("Can't add more ingredients")
		return false

	ingredients.append(ingredient)
	onUpdate()

func setIngredients(new_ingredients):
	ingredients = new_ingredients.duplicate()
	onUpdate()

func clearIngredients():
	ingredients.clear()
	onUpdate()

func onUpdate():
	calculateFlavorProfile()
	ingredientsColor = calculateColor()
	calculateMaterial()
	ingredients_changed.emit(ingredients)
	flavors_changed.emit(flavor_profile._to_amount_string())

func calculateFlavorProfile():
	flavor_profile.clearFlavorProfile()
	for ingredient in ingredients:
		flavor_profile.addIngredient(ingredient)

func calculateColor():
	if ingredients.size() == 0:
		return Constants.ingredientColorMap[Constants.ingredients.NONE]
	
	var color_list = []
	for ingredient in ingredients:
		color_list.append(Constants.ingredientColorMap[ingredient])
	return ColorUtility.BlendColorList(color_list)

func calculateMaterial():
	if ingredients.size() > 0:
		ingredientsMat.albedo_color = ingredientsColor
	else:
		ingredientsMat.albedo_color = Constants.ingredientColorMap[Constants.ingredients.NONE]

func ingredientsToString():
	var output = ""
	var ingredient_names = Constants.ingredients.keys()
	for ingredient in ingredients:
		output += ingredient_names[ingredient] + "\n"
	if ingredients.size() > 0:
		output = output.substr(0, output.length() - 1)
	return output
