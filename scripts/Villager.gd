extends CharacterBody3D

@export var state = "waiting"
@export var targetPathFollow: PathFollow3D
@export var moveMagnitude = 1.0

@onready var orderFlavor:FlavorProfile = generateOrder()

var moveTarget: Vector3

signal order_created(order_text)
signal order_served(order_value)

func _ready():
	order_created.connect($FlavorProfileUI.onLabelUpdate)
	order_created.emit(orderFlavor._to_amount_string())
	order_served.connect($FlavorProfileUI.onLabelUpdate)
	$villager/AnimationPlayer.animation_finished.connect(_on_sip_anim_finished.bind())
	$villager/AnimationPlayer.play("walk")

func _process(delta):
	match state:
		"arriving":
			behavior_arriving(delta)
		"leaving":
			behavior_leaving(delta)
		_:
			return

func useItem(held_item):
	match state:
		"waiting":
			return on_use_waiting(held_item)
		_:
			return false

func on_use_waiting(held_item):
	if $villager/AnimationPlayer.get_queue().size() != 0:
		return false
	if held_item == null:
		smile_and_wave()
		return true
	if "item_type" not in held_item:
		return false
	
	match held_item.item_type:
		"teacup":
			return on_use_teacup_waiting(held_item)
		_:
			return false

func on_use_teacup_waiting(held_item):
	if held_item.state != "hot_water":
		return false

	var order_comp = orderFlavor.compareFlavorArrays(held_item.ingredients.flavor_profile.flavors)
	var order_score = orderFlavor.getFlavorMagnitude() - order_comp
	displayPerformanceRating(order_score, orderFlavor.getFlavorMagnitude())

	held_item.ingredients.clearIngredients()
	held_item.updateState("empty")
	orderFlavor.clearFlavorProfile()
	order_served.emit(order_score)
	$FlavorProfileUI.onLabelUpdate("")
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
