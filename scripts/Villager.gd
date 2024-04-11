extends Node3D

var state = "idle"
var orderFlavor: FlavorProfile
var targetPath: Path3D
var moveTarget: Vector3

func _ready():
	orderFlavor = generateOrder()
	$FlavorProfileUI.updateLabel(orderFlavor)
	$villager/AnimationPlayer.play("idle")

func _process(_delta):
	match state:
		"arriving":
			pass

func useItem(_item):
	match state:
		"idle":
			if $villager/AnimationPlayer.get_queue().size() == 0:
				$villager/AnimationPlayer.play("wave")
				$villager/AnimationPlayer.queue("idle")

func setState(newState):
	state = newState

func generateOrder():
	var grassy = randi_range(0, 2)
	var floral = randi_range(0, 2)
	var fruity = randi_range(0, 2)
	var earthy = randi_range(0, 2)
	var smoky = randi_range(0, 2)
	var caffeine = randi_range(0, 2)
	return FlavorProfile.new(grassy, floral, fruity, earthy, smoky, caffeine)
