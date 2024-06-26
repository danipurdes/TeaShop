extends Node3D

@export var machine_type = "tea_tree"

func useItem(heldItem):
	if heldItem != null and heldItem.has_method("onUseItem") and heldItem.onUseItem(self):
		trimLeaves()
		return true
	return false

func trimLeaves():
	$LeavesMesh.visible = false
	$Hitbox.set_disabled(true)
	$LeafRefreshTimer.start()

func _on_leaf_refresh_timer_timeout():
	$LeavesMesh.visible = true
	$Hitbox.set_disabled(false)
