extends PanelContainer

@onready var held_item_label = $MarginContainer/HBoxContainer/Label_HeldItem

func on_held_item_changed(held_item):
	visible = held_item != null
	held_item_label.onLabelUpdate(held_item.item_type if held_item != null and "item_type" in held_item else "")
