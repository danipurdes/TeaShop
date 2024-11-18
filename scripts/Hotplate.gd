extends Area3D

class_name Hotplate

@export var item_type:String = "hotplate"
@export var machine_type:String = "hotplate"
@export var allow_list:Array[String] = ["kettle"]

var currentItem = null
var obj_attached_to = null

signal state_changed(state_text)

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
	currentItem.position = $ItemAnchor.global_position
	return currentItem.onUseStove()

func takeItem():
	currentItem.obj_attached_to = null
	currentItem = null

func is_item_allowed(itemType):
	return allow_list.size() > 0 and itemType in allow_list
	
func getName():
	return item_type
