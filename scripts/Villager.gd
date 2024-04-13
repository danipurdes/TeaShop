extends CharacterBody3D

@export var state = "waiting"
var orderFlavor: FlavorProfile
@export var targetPathFollow: PathFollow3D
var moveTarget: Vector3
@export var moveMagnitude = 1.0

func _ready():
	orderFlavor = generateOrder()
	$FlavorProfileUI.updateLabel(orderFlavor)
	$villager/AnimationPlayer.animation_finished.connect(_on_sip_anim_finished.bind())
	$villager/AnimationPlayer.play("walk")

func _process(delta):
	print_debug(state)
	match state:
		"arriving":
			targetPathFollow.progress += delta * moveMagnitude
			targetPathFollow.progress_ratio = clamp(targetPathFollow.progress_ratio, 0, .5)
			if (targetPathFollow != null):
				print_debug(str(targetPathFollow.progress) + ", " + str(targetPathFollow.progress_ratio))
			if targetPathFollow.progress_ratio == .5:
				state = "waiting"
				$villager/AnimationPlayer.play("idle")
			moveTarget = targetPathFollow.global_position
			look_at(moveTarget)
			velocity = moveTarget - global_position
			move_and_slide()
		"leaving":
			targetPathFollow.progress += delta * moveMagnitude
			if targetPathFollow.progress_ratio >= 1:
				queue_free()
			moveTarget = targetPathFollow.global_position
			look_at(moveTarget)
			velocity = moveTarget - global_position
			move_and_slide()

func useItem(item):
	match state:
		"waiting":
			if item != null and item.item_type == "teacup":
				get_node("/root/Node3D/Player").destroyHeldItem()
				orderFlavor.clearFlavorProfile()
				$FlavorProfileUI.updateLabel(orderFlavor)
				$villager/AnimationPlayer.play("sip")
			elif $villager/AnimationPlayer.get_queue().size() == 0:
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

func _on_sip_anim_finished(anim_name):
	if anim_name == "sip":
		state = "leaving"
		$villager/AnimationPlayer.play("walk")
