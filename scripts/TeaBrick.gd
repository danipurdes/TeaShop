extends Area3D

signal state_changed(state_text)

@export var item_type = "tea_brick"
@export var tea: Constants.ingredients
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var ingredientList = []
var ingredientMat = StandardMaterial3D.new()
var obj_attached_to = null

func _ready():
	ingredientMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	state_changed.connect(updateLabel)
	if tea != null:
		setup(tea)

func setup(newTea):
	setTea(newTea)

func useItem(item):
	if item != null and item.has_method("onUseItem") and item.onUseItem(self):
		for ingredient in item.ingredientList:
			addIngredient(ingredient)
		return true
	return false

func onUseItem(pinger):
	if "item_type" in pinger:
		match pinger.item_type:
			"tea_brick":
				for ingredient in ingredientList:
					if ingredient != Constants.ingredients.NONE:
						pinger.addIngredient(ingredient)
				setTea(Constants.ingredients.NONE)
				return true
			"dispenser":
				return true
			"teapot":
				pinger.ingredientList = ingredientList
				setTea(Constants.ingredients.NONE)
				return true
	return false

func setTea(newTeaType):
	flavor_profile.clearFlavorProfile()
	ingredientList.clear()
	addIngredient(newTeaType)
	state_changed.emit(getName())

func addIngredient(newIngredient):
	if ingredientList.size() == 1 and ingredientList[0] == Constants.ingredients.NONE:
		ingredientList.clear()
	if newIngredient != Constants.ingredients.NONE:
		flavor_profile.addIngredient(newIngredient)
		ingredientList.append(newIngredient)
	updateMaterial()
	state_changed.emit(getName())

func updateMaterial():
	if ingredientList.size() > 0:
		var color_list = []
		for ingredient in ingredientList:
			if ingredient != Constants.ingredients.NONE:
				color_list.append(Constants.ingredientColorMap[ingredient])
		ingredientMat.albedo_color = ColorUtility.BlendColorList(color_list)
		$IngredientAnchor/IngredientMesh.set_surface_override_material(0, ingredientMat)
	else:
		ingredientMat.albedo_color = Constants.ingredientColorMap[Constants.ingredients.NONE]
		$IngredientAnchor/IngredientMesh.set_surface_override_material(0, ingredientMat)

func updateLabel(new_label_text):
	$Label.text = new_label_text
	$FlavorProfileUI.updateLabel(flavor_profile)

func ingredientListToString():
	var output = ""
	var ingredient_names = Constants.ingredients.keys()
	for ingredient in ingredientList:
		output += ingredient_names[ingredient] + " "
	return output

func getName():
	return ingredientListToString() + (" blend" if ingredientList.size() > 1 else "")
