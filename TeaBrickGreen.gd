extends Area3D

@export var item_type = "green tea brick"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = getName()

func onUseItem(pinger):
	if "item_type" in pinger and pinger.item_type == "teapot":
		get_node("/root/Node3D/Player").destroyHeldItem()

func getName():
	return item_type
