extends Area3D

@export var item_type = "teakettle"
@export var state = "empty"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeaKettleLabel.text = getName()

func onUseItem(pinger):
	print("guh?")
	if "machine_type" in pinger and pinger.machine_type == "sink":
		print("bwuh?")
		if state == "empty":
			print("state empty")
			updateState("cold water")
		elif state == "cold water":
			print("state cold water")
			updateState("empty")
		elif state == "hot water":
			print("state hot water")
			updateState("empty")

func onUseStove():
	if state == "cold water":
		updateState("hot water")

func updateState(newState):
	state = newState
	$TeaKettleLabel.text = getName()

func getName():
	return item_type + " - " + state
