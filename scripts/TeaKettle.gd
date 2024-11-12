extends Area3D

@export var item_type = "teakettle"
@export var state = "empty"

var obj_attached_to = null

signal state_changed(newState)

func _ready():
	state_changed.connect($Label.onLabelUpdate)

func onUseItem(itemToUseOn):
	if "machine_type" not in itemToUseOn:
		return false
	
	match itemToUseOn.machine_type:
		"sink":
			return useOnSink()
		_:
			return false

func onUseStove():
	match state:
		"cold_water":
			updateState("hot_water")
			return true
		_:
			return false

func useOnSink():
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
		_:
			return false

func updateState(newState):
	state = newState
	$Steam.emitting = (newState == "hot_water")
	state_changed.emit(getName())

func getName():
	return state
