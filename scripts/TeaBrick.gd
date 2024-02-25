extends Area3D

@export var item_type = "tea_brick"
@export var mat_green_tea: Material
@export var mat_black_tea: Material
var flavor_profile = FlavorProfile.new()
var tea: Constants.ingredients
var ingredientList = []
var obj_attached_to = null

@onready var teaMatMap = {
	Constants.ingredients.GREEN_TEA: mat_green_tea,
	Constants.ingredients.BLACK_TEA: mat_black_tea
}

func _ready():
	updateLabel()
	$Mesh.set_surface_override_material(0, teaMatMap[tea])

func useItem(heldItem):
	return heldItem.onUseItem(self)

func onUseItem(pinger):
	if "item_type" in pinger and pinger.item_type == "teapot":
		get_node("/root/Node3D/Player").destroyHeldItem()
		updateLabel()
		return true
	return false

func setTea(newTeaType):
	tea = newTeaType
	flavor_profile.addIngredient(newTeaType)
	updateLabel()

func addIngredient(newIngredient):
	flavor_profile.addIngredient(newIngredient)
	ingredientList.append(newIngredient)
	updateLabel()

func updateLabel():
	$Label.text = getName()

func getName():
	return item_type + "\n" + Constants.ingredients.keys()[tea] + (" blend" if ingredientList.size() > 0 else "") + "\n" + flavor_profile._to_string()
