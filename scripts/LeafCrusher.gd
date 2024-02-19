extends Area3D

@export var machine_type = "leaf_crusher"
@export var obj_leaf_tray: PackedScene

#func ping():
#	if get_node("/root/Node3D").tea_leaf_count > 0 and $CrushTimer.is_stopped():
#		startCrushLeaves()
#		return true
#	return false

func useItem(heldItem):
	if heldItem.has_method("onUseItem") and heldItem.onUseItem(self):
		if "item_type" in heldItem and heldItem.item_type == "basket":
			startCrushLeaves()
			return true
	return false

func startCrushLeaves():
	$Mesh.visible = false
	$Hitbox.set_disabled(true)
	$CrushTimer.start()

func stopCrushLeaves():
	$Mesh.visible = true
	$Hitbox.set_disabled(false)
	var newLeafTray = obj_leaf_tray.instantiate()
	newLeafTray.position = $LeafTraySpawn.global_position
	get_node("/root/Node3D").add_child(newLeafTray)
