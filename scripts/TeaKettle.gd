extends Area3D

@export var item_type = "kettle"
@export_range(1,10) var servings_max = 3

var state:String = "empty"
var servings_current:int = 0
var obj_attached_to = null

signal state_changed(newState)

func _ready():
	state_changed.connect($Label.on_label_update)

func onUseItem(item_to_use_on):
	if "machine_type" not in item_to_use_on:
		return false
	
	match item_to_use_on.machine_type:
		"sink":
			return useOnSink()
		_:
			return false

func onUseStove():
	match state:
		"cold_water":
			update_state("hot_water")
			return true
		_:
			return false

func useOnSink():
	match state:
		"empty":
			update_state("cold_water")
			update_servings(servings_max)
			return true
		_:
			update_servings(0)
			return true

func update_state(new_state):
	if new_state == state:
		return
	state = new_state
	$Steam.emitting = (state == "hot_water")
	state_changed.emit(getName())

func update_servings(new_servings):
	if servings_current == new_servings:
		return
	servings_current = new_servings
	if servings_current <= 0:
		update_state("empty")

func getName():
	return str(servings_current) + "/" + str(servings_max)