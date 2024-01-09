extends Area3D

signal tea_tree_trim

@export var machine_type = "tea_tree"

func ping():
	trimLeaves()
	return true

func trimLeaves():
	$TeaTreeLeaves.visible = false
	$TeaTreeHitbox.set_disabled(true)
	$LeafRefreshTimer.start()
	tea_tree_trim.emit()

func _on_leaf_refresh_timer_timeout():
	$TeaTreeLeaves.visible = true
	$TeaTreeHitbox.set_disabled(false)
