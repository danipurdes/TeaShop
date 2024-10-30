extends Area3D

signal state_changed

@export var item_type = "teapot"
@export var state = "empty"
@export var servings = 0
@export var max_servings = 3
var flavor_profile = FlavorProfile.new([0,0,0,0,0,0])
var ingredientList = []
var obj_attached_to = null

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel(getName())
	flavor_profile.clearFlavorProfile()
	state_changed.connect(updateLabel)

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("full")
			heldItem.updateState("dirty")
			updateServings(max_servings)
			return true
	elif heldItem.item_type == "tea_brick":
		var held_flavor_profile = heldItem.flavor_profile.toArray()
		if heldItem.onUseItem(self):
			updateFlavorProfile(held_flavor_profile)
			return true
	return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state == "dirty":
			updateState("empty")
			return true
		elif state != "empty":
			updateState("dirty")
			flavor_profile.clearFlavorProfile()
			ingredientList.clear()
			updateServings(0)
			return true
	elif "item_type" in pinger and pinger.item_type == "teacup":
		if servings > 0:
			updateServings(servings - 1)
			pinger.ingredientList = ingredientList
			return true
	return false

func updateState(newState):
	state = newState
	$Steam.emitting = !(newState == "empty" or newState == "dirty")
	state_changed.emit(getName())

func updateFlavorProfile(newFlavorProfile):
	flavor_profile.addFlavorArray(newFlavorProfile)
	state_changed.emit(getName())

func updateServings(newServings):
	servings = newServings
	if servings <= 0:
		updateState("dirty")
		flavor_profile.clearFlavorProfile()
		ingredientList.clear()
	state_changed.emit(getName())

func updateLabel(new_label_text):
	$Label.text = new_label_text
	$ui_flavor_profile.updateLabel(flavor_profile)

func getName():
	return state + " " + item_type + ", servings: " + str(servings)
