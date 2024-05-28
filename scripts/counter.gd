extends StaticBody3D

@export var spawnObj:PackedScene
@export var teaType:Constants.ingredients

var spawnedObj

# Called when the node enters the scene tree for the first time.
func _ready():
	if spawnObj != null:
		spawnedObj = spawnObj.instantiate()
		spawnedObj.position = $CounterHotspot.global_position
		spawnedObj.rotation = $CounterHotspot.global_rotation
		spawnedObj.obj_attached_to = $CounterHotspot
		$CounterHotspot.currentItem = spawnedObj
		if "tea" in spawnedObj:
			spawnedObj.tea = teaType
		get_node("/root/Node3D").add_child.call_deferred(spawnedObj)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
