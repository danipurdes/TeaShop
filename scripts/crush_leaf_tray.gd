extends Area3D

signal state_changed

@export var item_type = "leaf_tray"
var obj_attached_to = null
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var ingredientList = []
var ingredientMat = StandardMaterial3D.new()

func onUseItem(itemToUseOn):
	if "machine_type" in itemToUseOn and itemToUseOn.machine_type == "oxidizer":
		get_node("/root/Node3D/Player").destroyHeldItem()
		return true
	return false

func setTea(newTeaType):
	flavor_profile.clearFlavorProfile()
	ingredientList.clear()
	addIngredient(newTeaType)

func addIngredient(newIngredient):
	if newIngredient in ingredientList:
		return
	if ingredientList.size() == 1 and ingredientList[0] == Constants.ingredients.NONE:
		ingredientList.clear()
	if newIngredient != Constants.ingredients.NONE:
		flavor_profile.addIngredient(newIngredient)
		ingredientList.append(newIngredient)
	updateMaterial()
	#updateLabel()

func updateMaterial():
	if ingredientList.size() > 0:
		var color_list = []
		for ingredient in ingredientList:
			if ingredient != Constants.ingredients.NONE:
				color_list.append(Constants.ingredientColorMap[ingredient])
		ingredientMat.albedo_color = ColorUtility.BlendColorList(color_list)
		$IngredientMesh.set_surface_override_material(0, ingredientMat)
	else:
		ingredientMat.albedo_color = Constants.ingredientColorMap[Constants.ingredients.NONE]
		$IngredientMesh.set_surface_override_material(0, ingredientMat)

func updateLabel(new_label_text):
	$Label.text = new_label_text

func ingredientListToString():
	var output = ""
	var ingredient_names = Constants.ingredients.keys()
	for ingredient in ingredientList:
		output += ingredient_names[ingredient] + " "
	return output

func getName():
	return ingredientListToString()
