extends Area3D

signal tea_tree_trim

func _ready():
	pass

func _process(_delta):
	pass

#func _on_input_event(_camera, event, _position, _normal, _shape_idx):
#	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
#		trimLeaves()

func ping():
	trimLeaves()

func trimLeaves():
	$TeaTreeLeaves.visible = false
	$TeaTreeHitbox.set_disabled(true)
	$LeafRefreshTimer.start()
	tea_tree_trim.emit()

func _on_leaf_refresh_timer_timeout():
	$TeaTreeLeaves.visible = true
	$TeaTreeHitbox.set_disabled(false)
