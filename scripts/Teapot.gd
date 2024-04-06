extends Area3D

@export var item_type = "teapot"
@export var state = "empty"
@export var servings = 0
@export var max_servings = 3
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var obj_attached_to = null

# Called when the node enters the scene tree for the first time.
func _ready():
	flavor_profile.clearFlavorProfile()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("hot_water")
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
			updateServings(0)
			return true
	elif "item_type" in pinger and pinger.item_type == "teacup":
		if servings > 0:
			updateServings(servings - 1)
			return true
	return false

func updateState(newState):
	state = newState
	$Steam.emitting = !(newState == "empty" or newState == "dirty")
	updateLabel()

func updateFlavorProfile(newFlavorProfile):
	flavor_profile.addFlavorArray(newFlavorProfile)
	updateLabel()

func updateServings(newServings):
	servings = newServings
	if servings <= 0:
		updateState("dirty")
		flavor_profile.clearFlavorProfile()
	updateLabel()

func updateLabel():
	$Label.text = getName()
	$ui_flavor_profile.updateLabel(flavor_profile)

func getName():
	return item_type + " - " + state + " - " + str(servings)
