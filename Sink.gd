extends Area3D

@export var machine_type = "sink"
var allowlist = ["teapot","teakettle","teacup"]

func useItem(heldItem):
	if heldItem.item_type in allowlist:
		if heldItem.has_method("onUseItem"):
			print("calling onUseItem")
			heldItem.onUseItem(self)

func getName():
	return machine_type
