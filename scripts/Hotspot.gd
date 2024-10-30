extends Area3D

class_name Hotspot

signal spawn_requested(objToSpawn)

@export var SpawnObj: PackedScene
@export var machine_type = "hotspot"
@export var allowlist = []

var currentItem = null

func _ready():
	spawn_requested.connect(spawnObject)
	if SpawnObj != null:
		var spawn_obj = SpawnObj.instantiate()
		spawn_obj.position = self.global_position
		get_node("/root/Node3D").add_child(spawn_obj)

func spawnObject(spawnObj):
	spawnObj.position = global_position
	spawnObj.rotation = global_rotation
	spawnObj.obj_attached_to = self
	currentItem = spawnObj
	get_node("/root/Node3D").add_child.call_deferred(spawnObj)

func useItem(item):
	if currentItem != null:
		return false
		
	if item == null or !isItemAllowed(item.item_type):
		return false
	
	currentItem = get_node("/root/Node3D/Player").requestDropHeldItem(self)
	currentItem.obj_attached_to = self
	return true

func takeItem():
	currentItem.obj_attached_to = null
	currentItem = null
	
func isItemAllowed(itemType):
	if allowlist.size() > 0:
		return itemType in allowlist
	return true
