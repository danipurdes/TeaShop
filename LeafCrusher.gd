extends Area3D

signal on_crush_enter
signal on_crush_exit

@export var machine_type = "leaf_crusher"

func _ready():
	pass

func _process(_delta):
	pass

func ping():
	if get_node("/root/Node3D").tea_leaf_count > 0 and $CrushTimer.is_stopped():
		startCrushLeaves()

func startCrushLeaves():
	$LeafCrusherMachine.visible = false
	$LeafCrusherHitbox.set_disabled(true)
	$CrushTimer.start()
	on_crush_enter.emit()

func stopCrushLeaves():
	$LeafCrusherMachine.visible = true
	$LeafCrusherHitbox.set_disabled(false)
	on_crush_exit.emit()
