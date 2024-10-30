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
	if heldItem == null:
		return true
	
	if "item_type" not in heldItem:
		return false
	
	match (heldItem.item_type):
		"teakettle":
			if heldItem.state == "hot_water" and state == "empty":
				updateState("full")
				heldItem.updateState("dirty")
				updateServings(max_servings)
				return true
			return false
		"tea_brick":
			var heldItemFlavors = heldItem.flavor_profile.flavors.duplicate()
			if heldItem.onUseItem(self):
				print_debug()
				updateFlavorProfile(heldItemFlavors)
				return true
			return false
		_:
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

func updateFlavorProfile(newFlavorArray):
	flavor_profile.addFlavorArray(newFlavorArray)
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
	$FlavorProfileUI.updateLabel(flavor_profile)

func getName():
	return state + " " + item_type + ", servings: " + str(servings)
