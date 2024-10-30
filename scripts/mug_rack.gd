extends Node3D

@export var spawnObj_0:PackedScene
@export var spawnObj_1:PackedScene
@export var spawnObj_2:PackedScene
@export var objAllowList:String

@onready var spawnObjs = [spawnObj_0, spawnObj_1, spawnObj_2]
@onready var hotspots = [$CounterHotspot0, $CounterHotspot1, $CounterHotspot2]

func _ready():
	var spawner = HotspotSpawner.new()
	spawner.SpawnHotspotObjects(spawnObjs, hotspots)
	
	if objAllowList != "":
		for hotspot in hotspots:
			hotspot.allowlist = [objAllowList]
