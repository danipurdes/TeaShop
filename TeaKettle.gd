extends Area3D

@export var item_type = "teakettle"
var state = "empty"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeaKettleLabel.text = getName()

func onPing2(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state == "empty":
			updateState("cold water")
		elif state == "cold water":
			updateState("empty")
		elif state == "hot water":
			updateState("empty")

func onUseStove():
	if state == "cold water":
		updateState("hot water")

func updateState(newState):
	state = newState
	$TeaKettleLabel.text = getName()

func getName():
	return item_type + " - " + state
