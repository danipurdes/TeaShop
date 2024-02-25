extends Area3D

@export var item_type = "leaf_tray"
var obj_attached_to = null

func onUseItem(itemToUseOn):
	if "machine_type" in itemToUseOn and itemToUseOn.machine_type == "oxidizer":
		get_node("/root/Node3D/Player").destroyHeldItem()
		return true
	return false
