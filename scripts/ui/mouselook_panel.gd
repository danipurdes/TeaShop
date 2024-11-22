extends PanelContainer

@onready var use_item_label = $MarginContainer/HBoxContainer/UseLabel

var held_item = null
var target_item = null

signal use_label_changed(new_label)
signal action_changed(verb)

func _ready():
	use_label_changed.connect(use_item_label.on_label_update)

func on_held_item_changed(new_held_item):
	visible = new_held_item != null
	held_item = new_held_item
	use_label_changed.emit(fetch_use_label())

func on_target_item_changed(new_target_item):
	target_item = new_target_item
	use_label_changed.emit(fetch_use_label())

func fetch_use_label():
	if target_item == null:
		action_changed.emit("normal")
		return ""

	if held_item == null:
		if "item_type" in target_item:
			action_changed.emit("up_arrow")
			return "pick up " + target_item.item_type
		action_changed.emit("normal")
		return ""
	
	if "machine_type" in target_item and "item_type" in held_item:
		match target_item.machine_type:
			"hotspot":
				action_changed.emit("down_arrow")
				return "set down " + held_item.item_type
			"hotplate":
				action_changed.emit("down_arrow")
				return "set down " + held_item.item_type
			_:
				action_changed.emit("normal")
				return ""

	if held_item.has_method("onUseItem") and target_item.has_method("useItem"):
		var held_item_key = held_item.getName() if held_item.has_method("getName") else ""
		var target_key = target_item.getName() if target_item.has_method("getName") else ""
		var use_key = held_item_key + "|" + target_key
		action_changed.emit("normal")
		return UseLabelUtility.itemUseLabelMap.get(use_key)
	
	action_changed.emit("normal")
	return ""
