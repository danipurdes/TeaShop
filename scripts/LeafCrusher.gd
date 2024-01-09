extends Area3D

signal on_crush_enter
signal on_crush_exit

@export var machine_type = "leaf_crusher"

func ping():
	if get_node("/root/Node3D").tea_leaf_count > 0 and $CrushTimer.is_stopped():
		startCrushLeaves()
		return true
	return false

func startCrushLeaves():
	$Mesh.visible = false
	$Hitbox.set_disabled(true)
	$CrushTimer.start()
	on_crush_enter.emit()

func stopCrushLeaves():
	$Mesh.visible = true
	$Hitbox.set_disabled(false)
	on_crush_exit.emit()
