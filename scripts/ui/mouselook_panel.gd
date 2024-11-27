extends PanelContainer

@onready var use_item_label = $MarginContainer/HBoxContainer/UseLabel

var held_item = null
var target_item = null

signal use_label_changed(new_label)
signal action_changed(verb)

func _ready():
	use_label_changed.connect(use_item_label.on_label_update)

func on_held_item_changed(new_held_item):
	held_item = new_held_item
	var new_use_label = fetch_use_label()
	visible = new_use_label != ""
	use_label_changed.emit(new_use_label)

func on_target_item_changed(new_target_item):
	target_item = new_target_item
	var new_use_label = fetch_use_label()
	visible = new_use_label != ""
	use_label_changed.emit(new_use_label)

func fetch_use_label():
	if target_item == null:
		action_changed.emit("normal")
		return ""

	if held_item == null:
		if "item_type" in target_item:
			action_changed.emit("up_arrow")
			return "pick up " + target_item.item_type
	
	if target_item != null and "machine_type" in target_item and held_item != null and "item_type" in held_item:
		match target_item.machine_type:
			"hotspot":
				if target_item.state == "full" or !target_item.is_item_allowed(held_item):
					action_changed.emit("normal")
					return ""
				action_changed.emit("down_arrow")
				return "set down " + held_item.item_type

	var held_item_key = get_item_key(held_item)
	var target_key = get_item_key(target_item)
	var use_key = held_item_key + "|" + target_key
	action_changed.emit("normal")
	if use_key in UseLabelUtility.itemUseLabelMap:
		print_debug(UseLabelUtility.itemUseLabelMap.get(use_key))
		return UseLabelUtility.itemUseLabelMap.get(use_key)
	
	action_changed.emit("normal")
	return ""

func get_item_key(item):
	if item == null:
		return "none"
	var output = ""
	if "item_type" in item:
		output += item.item_type
		if "state" in item:
			output += ":"
			output += item.state
	elif "machine_type" in item:
		output += item.machine_type
		if "state" in item:
			output += ":"
			output += item.state
	return output
