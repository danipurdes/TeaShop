extends Area3D

@export var item_type = "teacup"
@export var state = "empty"
@export var green_tea:Material
@export var black_tea:Material

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = getName()

func useItem(heldItem):
	if heldItem.item_type == "teakettle":
		if heldItem.state == "hot water" and state == "empty":
			updateState("hot water")
			heldItem.updateState("empty")
	if heldItem.item_type == "teapot":
		if state == "empty":
			if heldItem.tea_type == "green tea":
				updateState("green tea")
			elif heldItem.tea_type == "black tea":
				updateState("black tea")

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		if state != "empty":
			updateState("empty")

func updateState(newState):
	updateLiquidMaterial(newState)
	state = newState
	$Label.text = getName()

func updateLiquidMaterial(newState):
	match newState:
		"green tea":
			$tea_cup/tea_cup_liquid.visible = true
			$tea_cup/tea_cup_liquid.set_surface_override_material(0, green_tea)
		"black tea":
			$tea_cup/tea_cup_liquid.visible = true
			$tea_cup/tea_cup_liquid.set_surface_override_material(0, black_tea)
		"empty":
			$tea_cup/tea_cup_liquid.visible = false

func getName():
	return item_type + " - " + state