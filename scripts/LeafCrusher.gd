extends Area3D

@export var machine_type = "leaf_crusher"
@export var obj_leaf_tray: PackedScene

func _ready():
	$StatusLight.light_color = Color.GREEN

func useItem(heldItem):
	if heldItem != null and heldItem.has_method("onUseItem") and heldItem.onUseItem(self):
		if "item_type" in heldItem and heldItem.item_type == "basket":
			startCrushLeaves()
			return true
	return false

func startCrushLeaves():
	$StatusLight.light_color = Color.RED
	$Hitbox.set_disabled(true)
	$CrushTimer.start()

func stopCrushLeaves():
	$StatusLight.light_color = Color.GREEN
	$Hitbox.set_disabled(false)
	var newLeafTray = obj_leaf_tray.instantiate()
	newLeafTray.position = $LeafTraySpawn.global_position
	newLeafTray.setTea(Constants.ingredients.GREEN_TEA)
	get_node("/root/Node3D").add_child(newLeafTray)
