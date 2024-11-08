extends Label3D

@export var default_value = ""

func _ready():
	text = default_value
	$Sprite3D.set_custom_aabb(get_aabb())

func onLabelUpdate(newTextValue):
	text = str(newTextValue) if newTextValue != null else default_value
