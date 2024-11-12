extends PanelContainer

@onready var use_item_label = $MarginContainer/HBoxContainer/UseLabel

var held_item = null
var target_item = null

signal use_label_changed(verb)

func on_held_item_changed(new_held_item):
	visible = new_held_item != null
	held_item = new_held_item
	use_item_label.onLabelUpdate(fetchUseLabel())

func on_target_item_changed(new_target_item):
	target_item = new_target_item
	use_item_label.onLabelUpdate(fetchUseLabel())

func fetchUseLabel():
	if target_item == null:
		use_label_changed.emit("normal")
		return ""

	if held_item == null:
		if "item_type" in target_item:
			use_label_changed.emit("up_arrow")
			return "pick up " + target_item.item_type
		use_label_changed.emit("normal")
		return ""
	
	if "machine_type" in target_item and "item_type" in held_item:
		match target_item.machine_type:
			"hotspot":
				use_label_changed.emit("down_arrow")
				return "set down " + held_item.item_type
			"hotplate":
				use_label_changed.emit("down_arrow")
				return "set down " + held_item.item_type
			_:
				use_label_changed.emit("normal")
				return ""

	if held_item.has_method("onUseItem") and target_item.has_method("useItem"):
		var held_itemKey = held_item.getName() if held_item.has_method("getName") else ""
		var colliderKey = target_item.getName() if target_item.has_method("getName") else ""
		var useKey = held_itemKey + "|" + colliderKey
		use_label_changed.emit("normal")
		return UseLabelUtility.itemUseLabelMap.get(useKey)
	
	use_label_changed.emit("normal")
	return ""
