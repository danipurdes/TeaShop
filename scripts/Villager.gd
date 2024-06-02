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
			targetPathFollow.progress += delta * moveMagnitude
			targetPathFollow.progress_ratio = clamp(targetPathFollow.progress_ratio, 0, .5)
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
	var grassy = randi_range(0, 2)
	var floral = randi_range(0, 2)
	var fruity = randi_range(0, 2)
	var earthy = randi_range(0, 2)
	var smoky = randi_range(0, 2)
	var order = FlavorProfile.new(grassy, floral, fruity, earthy, smoky, 0)
	
	#Verify that the order isn't all zeroes
	if order.getFlavorMagnitude() == 0:
		var flavorIndex = randi_range(0, 4)
		match flavorIndex:
			0:
				order.grassy = 1
			1:
				order.floral = 1
			2:
				order.fruity = 1
			3:
				order.earthy = 1
			4:
				order.smoky = 1
	return order

func _on_sip_anim_finished(anim_name):
	if anim_name == "sip":
		state = "leaving"
		$villager/AnimationPlayer.play("walk")
		$PerformanceLabel.visible = false
