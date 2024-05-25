extends Node3D

signal current_order_changed(order_text)

@export var villager:PackedScene
var currentVillager = null
var currentPathFollower:PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnCooldownTimer.timeout.connect(trySpawnVillager)
	$SpawnCooldownTimer.start()

func trySpawnVillager():
	if villager != null and currentVillager == null and $SpawnCooldownTimer.is_stopped():
		spawnVillager()

func spawnVillager():
	var newVillager = villager.instantiate()
	currentVillager = newVillager
	currentVillager.tree_exiting.connect(clearCurrentVillager)
	currentVillager.order_created.connect(on_order_created)
	currentVillager.order_served.connect(on_order_served)
	currentVillager.position = Vector3.ZERO
	currentVillager.state = "arriving"
	$CustomerPath/CustomerPathFollow.progress = 0
	currentVillager.targetPathFollow = $CustomerPath/CustomerPathFollow
	add_child(currentVillager)

func clearCurrentVillager():
	currentVillager = null
	$SpawnCooldownTimer.start()

func on_order_created(order_text):
	current_order_changed.emit(order_text)

func on_order_served():
	current_order_changed.emit("")
