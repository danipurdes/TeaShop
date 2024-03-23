extends Area3D

class_name Hotspot

@export var SpawnObj: PackedScene
var machine_type = "hotspot"
var allowlist = []
var currentItem = null

func _ready():
	if SpawnObj != null:
		var spawn_obj = SpawnObj.instantiate()
		spawn_obj.position = self.global_position
		get_node("/root/Node3D").add_child(spawn_obj)

func useItem(item):
	if currentItem == null:
		if item != null and isItemAllowed(item.item_type):
			currentItem = get_node("/root/Node3D/Player").requestDropHeldItem(self)
			currentItem.obj_attached_to = self
			return true
	return false

func takeItem():
	currentItem.obj_attached_to = null
	currentItem = null
	
func isItemAllowed(itemType):
	if allowlist.size() > 0:
		return itemType in allowlist
	return true
