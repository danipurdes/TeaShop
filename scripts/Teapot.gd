extends Area3D

@export var item_type = "teapot"
@export var state = "empty"
var tea_type = Constants.tea_type.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeapotGreenLabel.text = getName()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("hot_water")
			heldItem.updateState("empty")
			return true
	if heldItem.item_type == "tea_brick":
		if heldItem.onUseItem(self):
			updateTeaType(heldItem.tea)
			return true
	return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty":
			updateState("empty")
			return true
	if item_type in pinger and pinger.item_type == "teacup":
		updateState("empty")
	return false

func updateState(newState):
	state = newState
	$TeapotGreenLabel.text = getName()

func updateTeaType(newType):
	tea_type = newType
	$TeapotGreenLabel.text = getName()

func getName():
	return item_type + "_" + state + "_" + str(tea_type)
