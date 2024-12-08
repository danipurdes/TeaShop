extends StaticBody3D

@export var machine_type = "sink"

func useItem(held_item):
	if held_item == null:
		return false
	if "item_type" not in held_item:
		return false
	if !held_item.has_method("onUseItem"):
		return false
	
	if held_item.onUseItem(self):
		$Bubbles.play()
		return true
	return false

func getName():
	return machine_type
