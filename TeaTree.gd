extends Area3D

signal tea_tree_trim

@export var machine_type = "tea_tree"

func _ready():
	pass

func _process(_delta):
	pass

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
