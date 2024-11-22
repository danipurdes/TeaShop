extends StaticBody3D

class_name Trashcan

@export var machine_type:String = "trashcan"
@export var allow_list:Array[String] = ["tea_brick"]

func useItem(item):
	if item == null:
		return false
	if "item_type" not in item:
		return false
	if !is_item_allowed(item.item_type):
		return false
	
	get_node("/root/Node3D/Player").request_drop_held_item(self)
	return true
	
func is_item_allowed(item_type):
	return allow_list.size() > 0 and item_type in allow_list