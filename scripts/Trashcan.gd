extends StaticBody3D

class_name Trashcan

@export var machine_type:String = "trashcan"
@export var allow_list:Array[String] = ["tea_brick"]

func useItem(item):
	if !is_item_allowed(item):
		return false
	
	get_node("/root/Node3D/Player").request_drop_held_item(self)
	return true
	
func is_item_allowed(item):
	if item == null:
		return false
	if "item_type" not in item:
		return false
	return allow_list.is_empty() or item.item_type in allow_list