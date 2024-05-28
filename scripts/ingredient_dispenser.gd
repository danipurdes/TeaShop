extends Area3D

@export var item_type = "dispenser"
@export var tea: Constants.ingredients
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var ingredientList = []
var ingredientMat = StandardMaterial3D.new()
var obj_attached_to = null

func _ready():
	ingredientMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	if tea != null:
		setup(tea)

func setup(newTea):
	setTea(newTea)

func useItem(item):
	if item != null and item.has_method("onUseItem") and item.onUseItem(self):
		if item.item_type == "tea_brick":
			for ingredient in ingredientList:
				item.addIngredient(ingredient)
			return true
	return false

func onUseItem(pinger):
	if "item_type" in pinger:
		match pinger.item_type:
			"tea_brick":
				for ingredient in ingredientList:
					if ingredient != Constants.ingredients.NONE:
						pinger.addIngredient(ingredient)
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
	updateLabel()

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

func updateLabel():
	$Label.text = getName()
	$FlavorProfileUI.updateLabel(flavor_profile)

func ingredientListToString():
	var output = ""
	var ingredient_names = Constants.ingredients.keys()
	for ingredient in ingredientList:
		output += ingredient_names[ingredient] + " "
	return output

func getName():
	return ingredientListToString() + (" blend" if ingredientList.size() > 1 else "")
