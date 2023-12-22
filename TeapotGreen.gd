extends Area3D

@export var item_type = "teapot"
var state = "empty"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeapotGreenLabel.text = getName()

func ping():
	#get_node("/root/Node3D/Player").attemptPickup(self)
	pass

func onPing2(pinger):
	if pinger.item_type == "sink" and state == "empty":
		updateState("full of water")
	elif pinger.item_type == "sink" and state == "full of water":
		updateState("empty")

func updateState(newState):
	state = newState
	$TeapotGreenLabel.text = item_type + " - " + state

func getName():
	return item_type + " - " + state
