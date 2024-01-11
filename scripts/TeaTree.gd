extends Area3D

@export var machine_type = "tea_tree"

func useItem(heldItem):
	if heldItem.has_method("onUseItem") and heldItem.onUseItem(self):
		trimLeaves()

func trimLeaves():
	$LeavesMesh.visible = false
	$Hitbox.set_disabled(true)
	$LeafRefreshTimer.start()

func _on_leaf_refresh_timer_timeout():
	$LeavesMesh.visible = true
	$Hitbox.set_disabled(false)
