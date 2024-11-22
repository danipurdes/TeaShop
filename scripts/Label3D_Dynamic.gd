extends Label3D

@export var default_value = ""

func _ready():
	text = default_value

func on_label_update(new_text_value):
	text = str(new_text_value) if new_text_value != null else default_value
