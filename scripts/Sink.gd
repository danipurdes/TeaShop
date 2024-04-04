extends StaticBody3D

@export var machine_type = "sink"
var allowlist = ["teapot","teakettle","teacup"]

func useItem(heldItem):
	if heldItem != null and heldItem.item_type in allowlist:
		if heldItem.has_method("onUseItem"):
			return heldItem.onUseItem(self)
	return false

func getName():
	return machine_type
