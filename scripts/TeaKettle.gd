extends Area3D

@export var item_type = "teakettle"
@export var state = "empty"
var obj_attached_to = null

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		match state:
			"empty":
				updateState("cold_water")
				return true
			"dirty":
				updateState("empty")
				return true
			"cold_water":
				updateState("dirty")
				return true
			"hot_water":
				updateState("dirty")
				return true
	return false

func onUseStove():
	if state == "cold_water":
		updateState("hot_water")
		return true
	return false

func updateState(newState):
	state = newState
	updateLabel()

func updateLabel():
	$Label.text = getName()

func getName():
	return item_type + "_" + state
