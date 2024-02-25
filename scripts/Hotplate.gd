extends Area3D

class_name Hotplate

var item_type = "hotplate"
var machine_type = "hotplate"
var allowlist = ["teakettle"]
var currentItem = null
var obj_attached_to = null

func ping():
	if currentItem == null:
		var heldItem = get_node("/root/Node3D/Player").getHeldItem()
		if heldItem != null and isItemAllowed(heldItem.item_type):
			currentItem = get_node("/root/Node3D/Player").requestDropHeldItem(self)
			currentItem.obj_attached_to = self
			currentItem.position = $ItemAnchor.global_position
			return currentItem.onUseStove()
	return false

func takeItem():
	currentItem.obj_attached_to = null
	currentItem = null

func isItemAllowed(itemType):
	print(itemType)
	if allowlist.size() > 0:
		return itemType in allowlist
	return itemType in allowlist
