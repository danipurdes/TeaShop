extends Area3D

@export var item_type = "leaf_tray"

func onUseItem(itemToUseOn):
	if "machine_type" in itemToUseOn and itemToUseOn.machine_type == "oxidizer":
		get_node("/root/Node3D/Player").destroyHeldItem()
		return true
	return false
