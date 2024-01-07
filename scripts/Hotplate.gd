extends Area3D

class_name Hotplate

var machine_type = "hotplate"
var allowlist = ["teakettle"]
var currentItem = null

func ping():
	if currentItem == null:
		var heldItem = get_node("/root/Node3D/Player").getHeldItem()
		if heldItem.item_type in allowlist:
			get_node("/root/Node3D/Player").requestDropHeldItem(self)
			if heldItem.has_method("onUseStove"):
				heldItem.onUseStove()
				return true
	return false

func isItemAllowed(itemType):
	print(itemType)
	if allowlist.size() > 0:
		return itemType in allowlist
	return itemType in allowlist
