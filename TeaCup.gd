extends Area3D

@export var item_type = "teacup"
@export var state = "empty"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = getName()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot water" and state == "empty":
			updateState("hot water")
			heldItem.updateState("empty")
	if heldItem.item_type == "teapot":
		if state == "empty":
			if heldItem.tea_type == "green tea":
				updateState("green tea")
			elif heldItem.tea_type == "black tea":
				updateState("black tea")

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty":
			updateState("empty")

func updateState(newState):
	state = newState
	$Label.text = getName()

func getName():
	return item_type + " - " + state
