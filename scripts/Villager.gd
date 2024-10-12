extends CharacterBody3D

signal order_created(order_text)
signal order_served

@export var state = "waiting"
var orderFlavor: FlavorProfile
@export var targetPathFollow: PathFollow3D
var moveTarget: Vector3
@export var moveMagnitude = 1.0

func _ready():
	orderFlavor = generateOrder()
	order_created.emit(orderFlavor._to_amount_string())
	$FlavorProfileUI.updateLabel(orderFlavor)
	$villager/AnimationPlayer.animation_finished.connect(_on_sip_anim_finished.bind())
	$villager/AnimationPlayer.play("walk")

func _process(delta):
	match state:
		"arriving":
			behavior_arriving(delta)
		"leaving":
			behavior_leaving(delta)

func useItem(item):
	match state:
		"waiting":
			if item != null and item.item_type == "teacup":
				if item.flavor_profile.getFlavorMagnitude() > 0:
					displayPerformanceRating(orderFlavor.compareFlavorProfiles(item.flavor_profile))
					item.flavor_profile.clearFlavorProfile()
					item.ingredientList.clear()
					item.updateState("dirty")
					orderFlavor.clearFlavorProfile()
					order_served.emit()
					$FlavorProfileUI.updateLabel(orderFlavor)
					$villager/AnimationPlayer.play("sip")
					return true
			elif $villager/AnimationPlayer.get_queue().size() == 0:
				$villager/AnimationPlayer.play("wave")
				$villager/AnimationPlayer.queue("idle")

func behavior_arriving(delta):
	targetPathFollow.progress += delta * moveMagnitude
	targetPathFollow.progress_ratio = clamp(targetPathFollow.progress_ratio, 0, .5)
	if targetPathFollow.progress_ratio == .5:
		state = "waiting"
		$villager/AnimationPlayer.play("idle")
	moveTarget = targetPathFollow.global_position
	look_at(moveTarget)
	velocity = moveTarget - global_position
	move_and_slide()

func behavior_leaving(delta):
	targetPathFollow.progress += delta * moveMagnitude
	if targetPathFollow.progress_ratio >= 1:
		queue_free()
	moveTarget = targetPathFollow.global_position
	look_at(moveTarget)
	velocity = moveTarget - global_position
	move_and_slide()

func displayPerformanceRating(rating):
	$PerformanceLabel.visible = true
	match rating:
		0:
			$PerformanceLabel.text = "Perfect!"
		1:
			$PerformanceLabel.text = "Great"
		2:
			$PerformanceLabel.text = "Good"
		3:
			$PerformanceLabel.text = "Okay"
		_:
			$PerformanceLabel.text = ":("

func setState(newState):
	state = newState

func generateOrder():
	var difficulty = randi_range(2, 5)
	var tea_type = randi_range(0, 2)
	var flavors = [0, 0, 0, 0, 0]
	
	match tea_type:
		1: 
			flavors[0] += 1
			difficulty -= 1
		2:
			flavors[4] += 1
			difficulty -= 1
		
	for i in difficulty:
		flavors[randi_range(0, 4)] += 1
	
	return FlavorProfile.new(flavors[0], flavors[1], flavors[2], flavors[3], flavors[4], 0)

func _on_sip_anim_finished(anim_name):
	if anim_name == "sip":
		state = "leaving"
		$villager/AnimationPlayer.play("walk")
		$PerformanceLabel.visible = false
