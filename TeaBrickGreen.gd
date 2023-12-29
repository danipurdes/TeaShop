extends Area3D

@export var item_type = "green tea brick"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = getName()

func onUseItem(item_type):
	if item_type == "hot water":
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getName():
	return item_type
