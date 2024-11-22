extends CharacterBody3D

@export var target_path_follow:PathFollow3D
@export_range(0.1,5,0.1) var move_magnitude:float = 1.0

@onready var order_flavor:FlavorProfile = FlavorProfile.new([0,0,0,0,0,0])

var state:String = "waiting"
var move_target:Vector3

signal state_changed(new_state)
signal order_created(order_text)
signal order_served(order_value)

func _ready():
	order_created.connect($FlavorProfileUI.on_flavors_changed)
	order_served.connect($FlavorProfileUI.on_flavors_changed)
	$villager/AnimationPlayer.animation_finished.connect(on_sip_anim_finished.bind())
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

	var order_magnitude = order_flavor.get_flavor_magnitude()
	var order_comp = order_flavor.compare_flavor_lists(held_item.ingredients.flavor_profile.flavors)
	var order_score = order_magnitude - order_comp
	display_performance_rating(order_score, order_flavor.get_flavor_magnitude())

	held_item.ingredients.clearIngredients()
	held_item.update_state("empty")
	order_flavor.clear_flavor_profile()
	order_served.emit(order_score)
	$villager/AnimationPlayer.play("sip")
	return true

func smile_and_wave():
	$villager/AnimationPlayer.play("wave")
	$villager/AnimationPlayer.queue("idle")

func behavior_arriving(delta):
	target_path_follow.progress_ratio = clamp(target_path_follow.progress_ratio, 0, .5)
	if target_path_follow.progress_ratio == .5:
		set_state("waiting")
		$villager/AnimationPlayer.play("idle")
		order_flavor = generate_order()
		order_created.emit(order_flavor)
		return
	behavior_walking(delta)

func behavior_leaving(delta):
	if target_path_follow.progress_ratio >= 1:
		queue_free()
		return
	behavior_walking(delta)

func behavior_walking(delta):
	target_path_follow.progress += delta * move_magnitude
	move_target = target_path_follow.global_position
	look_at(move_target)
	velocity = move_target - global_position
	move_and_slide()

func display_performance_rating(rating, total_rating):
	$PerformanceLabel.visible = true
	var output = ""
	for n in rating:
		output += "1"
	for m in total_rating - rating:
		output += "0"
	$PerformanceLabel.text = output

func set_state(new_state):
	if new_state == state:
		return
	state = new_state
	state_changed.emit(new_state)

func generate_order():
	var difficulty = randi_range(2, 5)
	var tea_type = randi_range(0, 2)
	var flavors:Array[int] = [0, 0, 0, 0, 0, 0]
	
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

func on_sip_anim_finished(anim_name):
	if anim_name == "sip":
		set_state("leaving")
		$villager/AnimationPlayer.play("walk")
		$PerformanceLabel.visible = false
