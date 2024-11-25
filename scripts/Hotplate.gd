extends Area3D

class_name Hotplate

@export var item_type:String = "hotplate"
@export var machine_type:String = "hotplate"
@export var allow_list:Array[String] = ["kettle"]

var state:String = "empty"

func _ready():
	$CounterHotspot.allow_list = allow_list
	$CounterHotspot.object_placed.connect(attach_item)
	$CounterHotspot.object_taken.connect(take_item)

func useItem(_item):
	# if currentItem != null:
	# 	return false
	# if item == null:
	# 	return false
	# if "item_type" not in item:
	# 	return false
	# if !is_item_allowed(item.item_type):
	# 	return false
	# if !attach_item(get_node("/root/Node3D/Player").request_drop_held_item(self)):
	# 	return false
	# return currentItem.onUseStove()
	return false

func attach_item(_item):
	# if item.has_method("onUseStove"):
	# 	item.onUseStove()
	update_state("full")

func take_item():
	update_state("empty")

func update_state(new_state):
	if new_state == state:
		return
	state = new_state
	#state_changed.emit(new_state)
	
func getName():
	return item_type
