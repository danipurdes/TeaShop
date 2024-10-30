extends Node3D

@export var spawnObj_0:PackedScene
@export var spawnObj_1:PackedScene
@export var spawnObj_2:PackedScene
@export var spawnObj_3:PackedScene
@export var spawnObj_4:PackedScene
@export var spawnObj_5:PackedScene
@export var objAllowList:String

@onready var spawnObjs = [spawnObj_0, spawnObj_1, spawnObj_2, spawnObj_3, spawnObj_4, spawnObj_5]
@onready var hotspots = [$CounterHotspot0, $CounterHotspot1, $CounterHotspot2, $CounterHotspot3, $CounterHotspot4, $CounterHotspot5]

func _ready():
	var spawner = HotspotSpawner.new()
	spawner.SpawnHotspotObjects(spawnObjs, hotspots)
	
	if objAllowList != "":
		for hotspot in hotspots:
			hotspot.allowlist = [objAllowList]
