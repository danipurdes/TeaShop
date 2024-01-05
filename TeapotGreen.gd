extends Area3D

@export var item_type = "teapot"
@export var state = "empty"
var tea_type = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeapotGreenLabel.text = getName()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("hot_water")
			heldItem.updateState("empty")
			return true
	if heldItem.item_type == "green_tea_brick":
		if state == "hot_water":
			if heldItem.onUseItem(self):
				updateTeaType("green_tea")
				return true
	if heldItem.item_type == "black_tea_brick":
		if state == "hot_water":
			if heldItem.onUseItem(self):
				updateTeaType("black_tea")
				return true
	return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty":
			updateState("empty")
			return true
	return false

func updateState(newState):
	state = newState
	$TeapotGreenLabel.text = getName()

func updateTeaType(newType):
	tea_type = newType
	$TeapotGreenLabel.text = getName()

func getName():
	return item_type + "_" + state + "_" + tea_type
