extends Area3D

@export var item_type = "teapot"
@export var state = "empty"
@export var servings = 0
@export var max_servings = 3
var flavor_profile = FlavorProfile.new()

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
		if heldItem.onUseItem(self):
			updateFlavorProfile(heldItem.flavor_profile)
			return true
	return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state == "dirty":
			updateState("empty")
			return true
		elif state != "empty":
			updateState("dirty")
			updateServings(0)
			return true
	elif "item_type" in pinger and pinger.item_type == "teacup":
		if servings > 0:
			updateServings(servings - 1)
			return true
	return false

func updateState(newState):
	state = newState
	updateLabel()

func updateFlavorProfile(newFlavorProfile):
	flavor_profile = newFlavorProfile
	updateLabel()

func updateServings(newServings):
	servings = newServings
	if servings <= 0:
		updateState("dirty")
		flavor_profile.clearFlavorProfile()
	updateLabel()

func updateLabel():
	$Label.text = getName()

func getName():
	return item_type + "\n" + state + "\n" + flavor_profile._to_string() + "\n" + str(servings)