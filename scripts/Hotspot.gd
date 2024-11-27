extends Area3D

class_name Hotspot

@export var SpawnObj:PackedScene
@export var machine_type:String = "hotspot"
@export var allow_list:Array[String] = []

var state:String = "empty"
var currentItem = null

signal state_changed(new_state)
signal spawn_requested(obj_to_spawn, spawn_data, allow_list)
signal object_placed()
signal object_taken()

func _ready():
	spawn_requested.connect(spawnObject)
	if SpawnObj != null:
		spawnObject(
			SpawnObj.instantiate(),
			Constants.ingredients.NONE,
			allow_list
		)

func spawnObject(obj_to_spawn, spawn_data, new_allow_list):
	obj_to_spawn.position = global_position
	obj_to_spawn.rotation = global_rotation
	attach_item(obj_to_spawn)

	if spawn_data != null and "ingredient_on_spawn" in obj_to_spawn:
		obj_to_spawn.ingredient_on_spawn = spawn_data

	allow_list.assign(new_allow_list)
	get_node("/root/Node3D").add_child.call_deferred(obj_to_spawn)

func useItem(item):
	if currentItem != null:
		return false
	if !is_item_allowed(item):
		return false
	return attach_item(get_node("/root/Node3D/Player").request_drop_held_item(self))

func attach_item(item):
	if !is_item_allowed(item):
		return false
	currentItem = item
	item.obj_attached_to = self
	object_placed.emit()
	update_state("full")

func take_item():
	currentItem.obj_attached_to = null
	currentItem = null
	object_taken.emit()
	update_state("empty")

func update_state(new_state):
	if new_state == state:
		return
	state = new_state
	state_changed.emit(state)
	
func is_item_allowed(item):
	if item == null:
		return false
	if "item_type" not in item:
		return false
	return allow_list.is_empty() or item.item_type in allow_list
