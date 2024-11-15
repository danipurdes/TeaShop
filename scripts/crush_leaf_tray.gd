extends Area3D

signal state_changed(state_text)

@export var item_type = "leaf_tray"
@export var tea: Constants.ingredients
@onready var ingredients = Ingredients.new()

var obj_attached_to = null

func onUseItem(itemToUseOn):
	if "machine_type" in itemToUseOn:
		match itemToUseOn.machine_type:
			"oxidizer":
				get_node("/root/Node3D/Player").destroyHeldItem()
				return true
			_:
				return false
	return false

func getName():
	return item_type
