extends StaticBody3D

class_name Trashcan

var machine_type = "trashcan"
var allowlist = ["tea_brick"]

func useItem(item):
	if item != null and isItemAllowed(item.item_type):
		get_node("/root/Node3D/Player").requestDropHeldItem(self)
		return true
	return false
	
func isItemAllowed(itemType):
	if allowlist.size() > 0:
		return itemType in allowlist
	return true
