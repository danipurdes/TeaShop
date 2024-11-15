extends StaticBody3D

@export var spawnObj:PackedScene
@export var spawnTea:Constants.ingredients

@onready var spawnObjs = [spawnObj]
@onready var spawnTeas = [spawnTea]
@onready var hotspots = [$CounterHotspot]
var spawnedObj

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawner = HotspotSpawner.new()
	spawner.SpawnHotspotObjects(spawnObjs, hotspots, spawnTeas)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
