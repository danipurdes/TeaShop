extends Area3D

class_name Hotspot

@export var SpawnObj:PackedScene
@export var machine_type:String = "hotspot"
@export var allow_list:Array[String] = []

var currentItem = null

signal spawn_requested(obj_to_spawn, spawn_data, allow_list)
signal object_taken()

func _ready():
	spawn_requested.connect(spawnObject)
	if SpawnObj != null:
		var spawn_obj = SpawnObj.instantiate()
		spawn_obj.position = self.global_position
		get_node("/root/Node3D").add_child.call_deferred(spawn_obj)

func spawnObject(obj_to_spawn, spawn_data, new_allow_list):
	obj_to_spawn.position = global_position
	obj_to_spawn.rotation = global_rotation
	obj_to_spawn.obj_attached_to = self
	currentItem = obj_to_spawn

	if spawn_data != null and "ingredient_on_spawn" in obj_to_spawn:
		obj_to_spawn.ingredient_on_spawn = spawn_data

	if new_allow_list.size() > 0:
		allow_list = new_allow_list.duplicate

	get_node("/root/Node3D").add_child.call_deferred(obj_to_spawn)

func useItem(item):
	if currentItem != null:
		return false
	if item == null:
		return false
	if "item_type" not in item:
		return false
	if !is_item_allowed(item.item_type):
		return false
	
	currentItem = get_node("/root/Node3D/Player").requestDropHeldItem(self)
	currentItem.obj_attached_to = self
	return true

func takeItem():
	currentItem.obj_attached_to = null
	currentItem = null
	object_taken.emit()
	
func is_item_allowed(itemType):
	return allow_list.size() == 0 or itemType in allow_list
