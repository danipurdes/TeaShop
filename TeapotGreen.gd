extends Area3D

@export var item_type = "teapot"
@export var state = "empty"
var tea_type = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeapotGreenLabel.text = getName()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot water" and state == "empty":
			updateState("hot water")
			heldItem.updateState("empty")
	if heldItem.item_type == "green tea brick":
		if state == "hot water":
			print_debug("made green tea")
			updateTeaType("green tea")
			heldItem.onUseItem(self)
	if heldItem.item_type == "black tea brick":
		if state == "hot water":
			print_debug("made black tea")
			updateTeaType("black tea")
			heldItem.onUseItem(self)

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty":
			updateState("empty")

func updateState(newState):
	state = newState
	$TeapotGreenLabel.text = getName()

func updateTeaType(newType):
	tea_type = newType
	$TeapotGreenLabel.text = getName()

func getName():
	return item_type + " - " + state + " - " + tea_type
