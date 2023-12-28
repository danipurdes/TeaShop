extends Area3D

@export var machine_type = "sink"
var allowlist = ["teapot","teakettle"]

func ping2(heldItem):
	if heldItem.item_type in allowlist:
		if heldItem.has_method("onPing2"):
			heldItem.onPing2(self)
