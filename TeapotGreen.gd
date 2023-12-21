extends Area3D

@export var item_type = "teapot"
var state = "empty"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ping():
	get_node("/root/Node3D/Player").attemptPickup(self, $TeapotGreenHitbox, $TeapotGreenMesh)

func onPing2(pinger):
	if pinger.item_type == "sink" and state == "empty":
		state = "full of water"
	elif pinger.item_type == "sink" and state == "full of water":
		state = "empty"

func getName():
	return item_type + " - " + state
