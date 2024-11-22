extends Node3D

signal current_order_changed(order_text)
signal score_change_requested(score_delta)

@export var villager:PackedScene

var current_villager = null
var current_path_follow:PathFollow3D

func _ready():
	$SpawnCooldownTimer.timeout.connect(try_spawn_villager)
	$SpawnCooldownTimer.start()

func try_spawn_villager():
	if villager == null:
		return
	if current_villager != null:
		return
	if not $SpawnCooldownTimer.is_stopped():
		return
	spawn_villager()

func spawn_villager():
	current_villager = villager.instantiate()
	current_villager.tree_exiting.connect(clear_current_villager)
	current_villager.order_created.connect(on_order_created)
	current_villager.order_served.connect(on_order_served)
	current_villager.position = Vector3.ZERO
	current_villager.set_state("arriving")
	$CustomerPath/CustomerPathFollow.progress = 0
	current_villager.target_path_follow = $CustomerPath/CustomerPathFollow
	add_child.call_deferred(current_villager)

func clear_current_villager():
	current_villager = null
	$SpawnCooldownTimer.start()

func on_order_created(order_flavors):
	current_order_changed.emit(order_flavors.to_amount_string())

func on_order_served(score):
	current_order_changed.emit("")
	score_change_requested.emit(score)
