extends CharacterBody3D

signal order_created(order_text)
signal order_served(order_value)

@export var state = "waiting"
@export var targetPathFollow: PathFollow3D
@export var moveMagnitude = 1.0
var orderFlavor: FlavorProfile
var moveTarget: Vector3

func _ready():
	orderFlavor = generateOrder()
	order_created.connect($FlavorProfileUI.onLabelUpdate)
	order_created.emit(orderFlavor._to_amount_string())
	$villager/AnimationPlayer.animation_finished.connect(_on_sip_anim_finished.bind())
	$villager/AnimationPlayer.play("walk")

func _process(delta):
	match state:
		"arriving":
			behavior_arriving(delta)
		"leaving":
			behavior_leaving(delta)

func useItem(item):
	if state != "waiting":
		return false
	if $villager/AnimationPlayer.get_queue().size() != 0:
		return false
	if item == null or "item_type" not in item or "flavor_profile" not in item:
		smile_and_wave()
		return false
	if item.item_type != "teacup" or item.flavor_profile.getFlavorMagnitude() == 0:
		return false
	
	var order_comp = orderFlavor.compareFlavorArrays(item.flavor_profile.flavors)
	var order_score = orderFlavor.getFlavorMagnitude() - order_comp
	displayPerformanceRating(order_score, orderFlavor.getFlavorMagnitude())
	item.ingredientList.clear()
	item.flavor_profile.clearFlavorProfile()
	item.updateState("dirty")
	orderFlavor.clearFlavorProfile()
	order_served.emit(order_score)
	$FlavorProfileUI.updateLabel(orderFlavor)
	$villager/AnimationPlayer.play("sip")
	return true

func smile_and_wave():
	$villager/AnimationPlayer.play("wave")
	$villager/AnimationPlayer.queue("idle")

func behavior_arriving(delta):
	targetPathFollow.progress_ratio = clamp(targetPathFollow.progress_ratio, 0, .5)
	if targetPathFollow.progress_ratio == .5:
		state = "waiting"
		$villager/AnimationPlayer.play("idle")
		return
	behavior_walking(delta)

func behavior_leaving(delta):
	if targetPathFollow.progress_ratio >= 1:
		queue_free()
		return
	behavior_walking(delta)

func behavior_walking(delta):
	targetPathFollow.progress += delta * moveMagnitude
	moveTarget = targetPathFollow.global_position
	look_at(moveTarget)
	velocity = moveTarget - global_position
	move_and_slide()

func displayPerformanceRating(rating, totalRating):
	$PerformanceLabel.visible = true
	var ratingText = ""
	for n in rating:
		ratingText += "1"
	for m in totalRating - rating:
		ratingText += "0"
	$PerformanceLabel.text = ratingText

func setState(newState):
	state = newState

func generateOrder():
	var difficulty = randi_range(2, 5)
	var tea_type = randi_range(0, 2)
	var flavors = [0, 0, 0, 0, 0, 0]
	
	match tea_type:
		1: 
			flavors[0] += 1
			difficulty -= 1
		2:
			flavors[4] += 1
			difficulty -= 1
		
	for i in difficulty:
		flavors[randi_range(0, 4)] += 1
	
	return FlavorProfile.new(flavors)

func _on_sip_anim_finished(anim_name):
	if anim_name == "sip":
		state = "leaving"
		$villager/AnimationPlayer.play("walk")
		$PerformanceLabel.visible = false
