extends Area3D

@export var item_type = "tea_brick"
@export var mat_green_tea: Material
@export var mat_black_tea: Material

var tea: Constants.tea_type
@onready var teaMatMap = {
	Constants.tea_type.GREEN_TEA: mat_green_tea,
	Constants.tea_type.BLACK_TEA: mat_black_tea
}

func _ready():
	$Label.text = getName()
	$Mesh.set_surface_override_material(0, teaMatMap[tea])

func onUseItem(pinger):
	if "item_type" in pinger and pinger.item_type == "teapot":
		get_node("/root/Node3D/Player").destroyHeldItem()
		return true
	return false

func setTea(newTeaType):
	tea = newTeaType

func getName():
	return item_type + "_" + str(tea)
