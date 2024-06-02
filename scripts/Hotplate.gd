extends Area3D

class_name Hotplate

signal state_changed(state_text)

var item_type = "hotplate"
var machine_type = "hotplate"
var allowlist = ["teakettle"]
var currentItem = null
var obj_attached_to = null

func useItem(item):
	# TODO: Replace heldItem with item param
	if currentItem == null:
		if item != null and isItemAllowed(item.item_type):
			currentItem = get_node("/root/Node3D/Player").requestDropHeldItem(self)
			currentItem.obj_attached_to = self
			currentItem.position = $ItemAnchor.global_position
			return currentItem.onUseStove()
	return false

func takeItem():
	currentItem.obj_attached_to = null
	currentItem = null

func isItemAllowed(itemType):
	if allowlist.size() > 0:
		return itemType in allowlist
	return itemType in allowlist
	
func getName():
	return "Stove"
