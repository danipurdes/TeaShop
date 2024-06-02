extends Area3D

signal state_changed(state_text)

@export var item_type = "teacup"
@export var state = "empty"
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var obj_attached_to = null
var ingredientList = []
var ingredientMat = StandardMaterial3D.new()

func _ready():
	ingredientMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	
	updateLabel(getName())
	updateMaterial()
	
	state_changed.connect(updateLabel)

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("full")
			heldItem.updateState("empty")
			return true
	if heldItem.item_type == "teapot":
		if heldItem.state != "empty" and state == "empty":
			var held_flavor_profile = heldItem.flavor_profile.toArray()
			if heldItem.onUseItem(self):
				updateState("full")
				updateFlavorProfile(held_flavor_profile)
				return true
	return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty" and state != "dirty":
			flavor_profile.clearFlavorProfile()
			ingredientList.clear()
			updateState("dirty")
			return true
		elif state == "dirty":
			updateState("empty")
			return false
	return false

func updateState(newState):
	state = newState
	$Steam.emitting = !(newState == "empty" or newState == "dirty")
	updateMaterial()
	state_changed.emit(getName())

func updateFlavorProfile(newFlavorProfile):
	flavor_profile.addFlavorArray(newFlavorProfile)
	updateMaterial()
	state_changed.emit(getName())

func updateMaterial():
	if ingredientList.size() > 0:
		var color_list = []
		for ingredient in ingredientList:
			if ingredient != Constants.ingredients.NONE:
				color_list.append(Constants.ingredientColorMap[ingredient])
		ingredientMat.albedo_color = ColorUtility.BlendColorList(color_list)
		$tea_cup/tea_cup_liquid.set_surface_override_material(0, ingredientMat)
	else:
		ingredientMat.albedo_color = Constants.ingredientColorMap[Constants.ingredients.NONE]
		$tea_cup/tea_cup_liquid.set_surface_override_material(0, ingredientMat)

func updateLabel(new_label_text):
	$Label.text = new_label_text
	$ui_flavor_profile.updateLabel(flavor_profile)

func getName():
	return state + " " + item_type
