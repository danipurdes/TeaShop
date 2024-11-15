extends Node3D

@export var spawnObj_0:PackedScene
@export var spawnObj_1:PackedScene
@export var spawnObj_2:PackedScene
@export var spawnObj_3:PackedScene
@export var spawnObj_4:PackedScene
@export var spawnObj_5:PackedScene
@export var spawnObj_6:PackedScene
@export var spawnObj_7:PackedScene
@export var spawnObj_8:PackedScene
@export var spawnTea_0:Constants.ingredients
@export var spawnTea_1:Constants.ingredients
@export var spawnTea_2:Constants.ingredients
@export var spawnTea_3:Constants.ingredients
@export var spawnTea_4:Constants.ingredients
@export var spawnTea_5:Constants.ingredients
@export var spawnTea_6:Constants.ingredients
@export var spawnTea_7:Constants.ingredients
@export var spawnTea_8:Constants.ingredients
@export var objAllowList:String

@onready var spawnObjs = [spawnObj_0, spawnObj_1, spawnObj_2, spawnObj_3, spawnObj_4, spawnObj_5, spawnObj_6, spawnObj_7, spawnObj_8]
@onready var spawnTeas = [spawnTea_0, spawnTea_1, spawnTea_2, spawnTea_3, spawnTea_4, spawnTea_5, spawnTea_6, spawnTea_7, spawnTea_8]
@onready var hotspots = [$CounterHotspot0, $CounterHotspot1, $CounterHotspot2, $CounterHotspot3, $CounterHotspot4, $CounterHotspot5, $CounterHotspot6, $CounterHotspot7, $CounterHotspot8]

func _ready():
	var spawner = HotspotSpawner.new()
	spawner.SpawnHotspotObjects(spawnObjs, hotspots, spawnTeas)
	
	if objAllowList != "":
		for hotspot in hotspots:
			hotspot.allowlist = [objAllowList]
