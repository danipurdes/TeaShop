extends CharacterBody3D

@export var target_path_follow:PathFollow3D
@export_range(0.1,5,0.1) var move_magnitude:float = 1.0

@onready var order_flavor:FlavorProfile = FlavorProfile.new([0,0,0,0,0,0])
@onready var animation_player:AnimationPlayer = $villager_cat/AnimationPlayer

var state:String = "waiting"
var move_target:Vector3

signal state_changed(new_state)
signal order_changed(order_text)
signal order_served(order_value)

func _ready():
	order_changed.connect($FlavorProfileUI.on_flavors_changed)
	animation_player.animation_finished.connect(on_sip_anim_finished.bind())
	animation_player.play("walkAction")

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
	if animation_player.get_queue().size() != 0:
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

	held_item.ingredients.clear_ingredients()
	held_item.update_state("empty")
	order_flavor.clear_flavor_profile()
	order_changed.emit(order_flavor)
	order_served.emit(order_score)
	animation_player.play("sipAction")
	return true

func smile_and_wave():
	animation_player.play("waveAction")
	animation_player.queue("idleAction")

func behavior_arriving(delta):
	target_path_follow.progress_ratio = clamp(target_path_follow.progress_ratio, 0, .5)
	if target_path_follow.progress_ratio == .5:
		set_state("waiting")
		animation_player.play("idleAction")
		order_flavor = generate_order()
		order_changed.emit(order_flavor)
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
	var difficulty = randi_range(2, 4)
	var tea_index = randi_range(0, 3)
	var teas = [Constants.ingredients.NONE, Constants.ingredients.WHITE_TEA, Constants.ingredients.GREEN_TEA, Constants.ingredients.BLACK_TEA]
	var flavors:FlavorProfile = FlavorProfile.new([0, 0, 0, 0, 0, 0])
	
	if tea_index > 0:
		flavors.add_ingredient(Constants.ingredients[teas[tea_index]])
		difficulty -= 1

	for i in difficulty:
		flavors.flavors[randi_range(0, 5)] += 1
	return flavors

func on_sip_anim_finished(anim_name):
	if anim_name == "sipAction":
		set_state("leaving")
		animation_player.play("walkAction")
		$PerformanceLabel.visible = false
