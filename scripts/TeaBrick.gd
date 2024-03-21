extends Area3D

@export var item_type = "tea_brick"
@export var color_ingredient: Color
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
	return heldItem.onUseItem(self)

func onUseItem(pinger):
	if "item_type" in pinger:
		match pinger.item_type:
			"tea_brick":
				pinger.addIngredient(tea)
				setTea(Constants.ingredients.NONE)
				return true
			"teapot":
				get_node("/root/Node3D/Player").destroyHeldItem()
				setTea(Constants.ingredients.NONE)
				return true
	return false

func setTea(newTeaType):
	flavor_profile.clearFlavorProfile()
	tea = newTeaType
	addIngredient(newTeaType)
	updateMaterial(newTeaType)
	updateLabel()

func addIngredient(newIngredient):
	flavor_profile.addIngredient(newIngredient)
	ingredientList.append(newIngredient)
	updateLabel()

func updateMaterial(_tea):
	var ingredientMat = StandardMaterial3D.new()
	ingredientMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	color_ingredient = Constants.ingredientColorMap[_tea]
	ingredientMat.albedo_color = color_ingredient
	$Mesh.set_surface_override_material(0, ingredientMat)

func updateLabel():
	$Label.text = getName()
	$ui_flavor_profile.updateLabel(flavor_profile)

func getName():
	return item_type + "\n" + Constants.ingredients.keys()[tea] + (" blend" if ingredientList.size() > 0 else "")
