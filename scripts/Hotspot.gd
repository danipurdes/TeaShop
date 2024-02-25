extends Area3D

class_name Hotspot

var machine_type = "hotspot"
var allowlist = []
var currentItem = null

func ping():
	if currentItem == null:
		var heldItem = get_node("/root/Node3D/Player").getHeldItem()
		if heldItem != null and isItemAllowed(heldItem.item_type):
			currentItem = get_node("/root/Node3D/Player").requestDropHeldItem(self)
			currentItem.obj_attached_to = self
			return true
	return false

func takeItem():
	currentItem.obj_attached_to = null
	currentItem = null
	
func isItemAllowed(itemType):
	if allowlist.size() > 0:
		return itemType in allowlist
	return true
