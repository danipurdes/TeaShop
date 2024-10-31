extends Label

@export var default_value = ""

func _ready():
	text = default_value

func onLabelUpdate(newTextValue):
	text = str(newTextValue) if newTextValue != null else default_value
