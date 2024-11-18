extends Node3D

@export var machine_type = "tea_tree"
@onready var leaf_refresh_timer = $LeafRefreshTimer

func _ready():
	leaf_refresh_timer.timeout.connect(refresh_leaves)

func useItem(heldItem):
	if heldItem == null:
		return false
	if !heldItem.has_method("onUseItem"):
		return false
	if "item_type" not in heldItem:
		return heldItem.onUseItem(self)

	match heldItem.item_type:
		"basket":
			var leaves_deposited = heldItem.deposit_leaves(1)
			if leaves_deposited > 0:
				trim_leaves()
			return leaves_deposited > 0
		_:
			return false

func trim_leaves():
	$LeavesMesh.visible = false
	$Hitbox.set_disabled(true)
	$LeafRefreshTimer.start()

func refresh_leaves():
	$LeavesMesh.visible = true
	$Hitbox.set_disabled(false)
