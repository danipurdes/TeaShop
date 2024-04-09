extends Node3D

@export var villager:PackedScene
var currentVillager

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
	currentVillager.position = Vector3.ZERO
	add_child(currentVillager)

func despawnVillager():
	if currentVillager != null:
		currentVillager.queue_free()
		currentVillager = null
		$SpawnCooldownTimer.start()
