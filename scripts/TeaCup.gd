extends Area3D

@export var item_type = "teacup"
@export var state = "empty"
@export var tea_type = Constants.tea_type.NONE
@export var green_tea:Material
@export var black_tea:Material

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = getName()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot_water" and state == "empty":
			updateState("hot_water")
			heldItem.updateState("empty")
			return true
	if heldItem.item_type == "teapot":
		if heldItem.state != "empty" and state == "empty":
			if heldItem.tea_type != Constants.tea_type.NONE:
				updateState("hot_water")
				updateTeaType(heldItem.tea_type)
				return true
	return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty":
			updateState("empty")
			return true
	return false

func updateState(newState):
	state = newState
	$Label.text = getName()

func updateTeaType(newTea):
	tea_type = newTea
	updateLiquidMaterial(tea_type)
	$Label.text = getName()

func updateLiquidMaterial(newTea):
	match newTea:
		Constants.tea_type.GREEN_TEA:
			$tea_cup/tea_cup_liquid.visible = true
			$tea_cup/tea_cup_liquid.set_surface_override_material(0, green_tea)
		Constants.tea_type.BLACK_TEA:
			$tea_cup/tea_cup_liquid.visible = true
			$tea_cup/tea_cup_liquid.set_surface_override_material(0, black_tea)
		_:
			$tea_cup/tea_cup_liquid.visible = false

func getName():
	return item_type + "_" + state + "_" + str(tea_type)
