extends Area3D

@export var item_type = "black_tea_brick"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = getName()

func onUseItem(pinger):
	if "item_type" in pinger and pinger.item_type == "teapot":
		get_node("/root/Node3D/Player").destroyHeldItem()
		return true
	return false

func getName():
	return item_type
