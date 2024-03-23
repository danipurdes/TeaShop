extends Area3D

@export var item_type = "teacup"
@export var state = "empty"
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var obj_attached_to = null

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()

# TODO: Update with new flavor and ingredient changes
func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("hot_water")
			heldItem.updateState("empty")
			return true
	if heldItem.item_type == "teapot":
		if heldItem.state != "empty" and state == "empty":
			var held_flavor_profile = heldItem.flavor_profile.toArray()
			if heldItem.onUseItem(self):
				updateState("hot_water")
				updateLiquidMaterial()
				updateFlavorProfile(held_flavor_profile)
				return true
	return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty" and state != "dirty":
			flavor_profile.clearFlavorProfile()
			updateState("dirty")
			return true
		elif state == "dirty":
			updateState("empty")
			return false
	return false

func updateState(newState):
	state = newState
	updateLabel()

func updateFlavorProfile(newFlavorProfile):
	flavor_profile.addFlavorArray(newFlavorProfile)
	updateLabel()

func updateLiquidMaterial():
	#TODO: Write method
	pass

func updateLabel():
	$Label.text = getName()
	$ui_flavor_profile.updateLabel(flavor_profile)

func getName():
	return item_type + "\n" + state #+ "\n" + flavor_profile._to_string()
