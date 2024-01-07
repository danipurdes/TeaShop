extends Area3D

@export var item_type = "teakettle"
@export var state = "empty"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeaKettleLabel.text = getName()

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		match state:
			"empty":
				updateState("cold_water")
				return true
			"cold_water":
				updateState("empty")
				return true
			"hot_water":
				updateState("empty")
				return true
	return false

func onUseStove():
	if state == "cold_water":
		updateState("hot_water")

func updateState(newState):
	state = newState
	$TeaKettleLabel.text = getName()

func getName():
	return item_type + "_" + state
