extends Area3D

@export var item_type = "black tea brick"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = getName()

func getName():
	return item_type
