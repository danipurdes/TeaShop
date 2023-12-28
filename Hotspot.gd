extends Area3D

class_name Hotspot

var machine_type = "hotspot"
var allowlist = []
var currentItem = null

func ping():
	print("mercury is in retrograde")
	if currentItem == null:
		print("spiderpunk my beloved")
		get_node("/root/Node3D/Player").requestDropHeldItem(self)

func isItemAllowed(itemType):
	if allowlist.size() > 0:
		return itemType in allowlist
	return true
