extends Node3D

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
	currentVillager.position = Vector3.ZERO
	currentVillager.state = "arriving"
	$CustomerPath/CustomerPathFollow.progress = 0
	currentVillager.targetPathFollow = $CustomerPath/CustomerPathFollow
	add_child(currentVillager)

func clearCurrentVillager():
	currentVillager = null
	$SpawnCooldownTimer.start()
