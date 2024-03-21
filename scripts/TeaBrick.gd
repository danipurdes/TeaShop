extends Area3D

@export var item_type = "tea_brick"
#@export var color_ingredient: Color
@export var tea: Constants.ingredients
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var ingredientList = []
var obj_attached_to = null

func _ready():
	if tea != null:
		setup(tea)

func setup(_tea):
	setTea(_tea)

func useItem(heldItem):
	if heldItem != null and heldItem.has_method("onUseItem") and heldItem.onUseItem(self):
		for ingredient in heldItem.ingredientList:
			if ingredient != Constants.ingredients.NONE:
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
			"teapot":
				setTea(Constants.ingredients.NONE)
				return true
	return false

func setTea(newTeaType):
	flavor_profile.clearFlavorProfile()
	ingredientList.clear()
	tea = newTeaType
	addIngredient(newTeaType)

func addIngredient(newIngredient):
	flavor_profile.addIngredient(newIngredient)
	ingredientList.append(newIngredient)
	updateMaterial()
	updateLabel()

func updateMaterial():
	if ingredientList.size() > 0:
		var ingredientMat = StandardMaterial3D.new()
		ingredientMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		var red = 0
		var green = 0
		var blue = 0
		var alpha = 0
		for ingredient in ingredientList:
			red += Constants.ingredientColorMap[ingredient].r
			green += Constants.ingredientColorMap[ingredient].g
			blue += Constants.ingredientColorMap[ingredient].b
			alpha += Constants.ingredientColorMap[ingredient].a
		red *= 1.0 / ingredientList.size()
		green *= 1.0 / ingredientList.size()
		blue *= 1.0 / ingredientList.size()
		red = pow(red, 1.0 / ingredientList.size())
		green = pow(green, 1.0 / ingredientList.size())
		blue = pow(blue, 1.0 / ingredientList.size())
		alpha *= 1.0 / ingredientList.size()
		var blend_color = Color(red, green, blue, alpha)
		
		ingredientMat.albedo_color = blend_color
		$Mesh.set_surface_override_material(0, ingredientMat)

func updateLabel():
	$Label.text = getName()
	$ui_flavor_profile.updateLabel(flavor_profile)

func getName():
	return item_type + "\n" + Constants.ingredients.keys()[tea] + (" blend" if ingredientList.size() > 0 else "")
