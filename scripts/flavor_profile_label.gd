extends Node3D

@export var default_value = ""

signal flavor_text_changed(new_label_text)

func _ready():
	flavor_text_changed.connect($Label.on_label_update)
	$Label.default_value = default_value

func on_flavors_changed(new_flavors):
	flavor_text_changed.emit(new_flavors.to_amount_string())
