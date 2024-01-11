extends Area3D

signal tea_tree_trim

@export var machine_type = "tea_tree"

func ping():
	trimLeaves()
	return true

func useItem(heldItem):
	if heldItem.has_method("onUseItem") and heldItem.onUseItem(self):
		#if heldItem.item_type == "basket":
		trimLeaves()

func trimLeaves():
	$LeavesMesh.visible = false
	$Hitbox.set_disabled(true)
	$LeafRefreshTimer.start()
	tea_tree_trim.emit()

func _on_leaf_refresh_timer_timeout():
	$LeavesMesh.visible = true
	$Hitbox.set_disabled(false)
