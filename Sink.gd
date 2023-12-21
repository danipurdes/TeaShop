extends Area3D

@export var item_type = "sink"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ping2():
	var heldItem = get_node("/root/Node3D/Player").getHeldItem()
	if heldItem.item_type == "teapot":
		if heldItem.has_method("onPing2"):
			heldItem.onPing2(self)
