extends Area3D

@export var item_type = "teacup"
@export var state = "empty"
@export var green_tea:Material
@export var black_tea:Material
var flavor_profile = FlavorProfile.new()
var obj_attached_to = null

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("hot_water")
			heldItem.updateState("empty")
			return true
	if heldItem.item_type == "teapot":
		if heldItem.state != "empty" and state == "empty":
			if heldItem.onUseItem(self):
				updateState("hot_water")
				updateLiquidMaterial()
				updateFlavorProfile(heldItem.flavor_profile)
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
	flavor_profile.copyFlavorProfile(newFlavorProfile)
	updateLabel()

func updateLiquidMaterial():
#	match newTea:
#		Constants.tea_type.GREEN_TEA:
#			$tea_cup/tea_cup_liquid.visible = true
			$tea_cup/tea_cup_liquid.set_surface_override_material(0, green_tea)
#		Constants.tea_type.BLACK_TEA:
#			$tea_cup/tea_cup_liquid.visible = true
#			$tea_cup/tea_cup_liquid.set_surface_override_material(0, black_tea)
#		_:
#			$tea_cup/tea_cup_liquid.visible = false

func updateLabel():
	$Label.text = getName()
	$ui_flavor_profile/Grassy_Amount.text = str(flavor_profile.grassy)
	$ui_flavor_profile/Floral_Amount.text = str(flavor_profile.floral)
	$ui_flavor_profile/Fruity_Amount.text = str(flavor_profile.fruity)
	$ui_flavor_profile/Earthy_Amount.text = str(flavor_profile.earthy)
	$ui_flavor_profile/Smoky_Amount.text = str(flavor_profile.smoky)

func getName():
	return item_type + "\n" + state #+ "\n" + flavor_profile._to_string()
