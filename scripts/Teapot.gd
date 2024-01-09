extends Area3D

@export var item_type = "teapot"
@export var state = "empty"
@export var servings = 0
@export var max_servings = 3
var tea_type = Constants.tea_type.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeapotGreenLabel.text = getName()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("hot_water")
			heldItem.updateState("dirty")
			updateServings(max_servings)
			return true
	elif heldItem.item_type == "tea_brick":
		if heldItem.onUseItem(self):
			updateTeaType(heldItem.tea)
			updateServings(max_servings)
			return true
	return false

func onUseItem(pinger):
	print_debug(servings)
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty":
			updateState("dirty")
			updateTeaType(Constants.tea_type.NONE)
			updateServings(0)
			return true
		elif state == "dirty":
			updateState("empty")
			return true
	elif "item_type" in pinger and pinger.item_type == "teacup":
		print_debug(servings)
		if servings > 0:
			print_debug(servings)
			updateServings(servings - 1)
			print_debug(servings)
			if servings <= 0:
				updateState("dirty")
			return true
	return false

func updateState(newState):
	state = newState
	$TeapotGreenLabel.text = getName()

func updateTeaType(newType):
	tea_type = newType
	$TeapotGreenLabel.text = getName()

func updateServings(newServings):
	servings = newServings
	$TeapotGreenLabel.text = getName()

func getName():
	return item_type + "_" + state + "_" + str(tea_type) + "_" + str(servings)
