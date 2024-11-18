extends Node3D

@export var allow_list:Array[String] = ["teacup"]

@export_group("Object Spawns")
@export_subgroup("Left")
@export var spawnObj_0:PackedScene
@export_subgroup("Middle")
@export var spawnObj_1:PackedScene
@export_subgroup("Right")
@export var spawnObj_2:PackedScene

@onready var spawnObjs = [spawnObj_0, spawnObj_1, spawnObj_2]
@onready var hotspots = [$CounterHotspot0, $CounterHotspot1, $CounterHotspot2]

func _ready():
	var spawner = HotspotSpawner.new()
	spawner.SpawnHotspotObjects(spawnObjs, hotspots, null, allow_list)
