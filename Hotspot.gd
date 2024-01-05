extends Area3D

class_name Hotspot

var machine_type = "hotspot"
var allowlist = []
var currentItem = null

func ping():
	if currentItem == null:
		var heldItem = get_node("/root/Node3D/Player").getHeldItem()
		if heldItem != null and isItemAllowed(heldItem.item_type):
			get_node("/root/Node3D/Player").requestDropHeldItem(self)
			return true
	return false

func isItemAllowed(itemType):
	if allowlist.size() > 0:
		return itemType in allowlist
	return true
