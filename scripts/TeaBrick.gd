extends Area3D

signal state_changed(state_text)

@export var item_type = "tea_brick"
@export var tea: Constants.ingredients
var flavor_profile = FlavorProfile.new([0,0,0,0,0,0])
var ingredientList = []
var ingredientMat = StandardMaterial3D.new()
var obj_attached_to = null

func _ready():
	ingredientMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	state_changed.connect(updateLabel)
	if tea != null:
		setTea(tea)

func useItem(item):
	if item == null:
		return false
	
	if !item.has_method("onUseItem"):
		return false
		
	if !item.onUseItem(self):
		return false
		
	for ingredient in item.ingredientList:
		addIngredient(ingredient)
	return true

func onUseItem(pinger):
	if "item_type" not in pinger:
		return false
		
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
			pinger.ingredientList = ingredientList.duplicate()
			setTea(Constants.ingredients.NONE)
			return true
		_:
			return false

func setTea(newTeaType):
	flavor_profile.clearFlavorProfile()
	ingredientList.clear()
	addIngredient(newTeaType)
	state_changed.emit(getName())

func isActualIngredient(ingredient):
	return ingredient != Constants.ingredients.NONE
	
func addIngredient(newIngredient):
	if newIngredient == Constants.ingredients.NONE:
		return
	
	ingredientList = ingredientList.filter(isActualIngredient)
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
	print_debug(output)
	return output

func getName():
	return ingredientListToString() + (" blend" if ingredientList.size() > 1 else "")
