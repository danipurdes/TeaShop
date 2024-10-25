extends Node3D

@export var spawnObj_0:PackedScene
@export var spawnObj_1:PackedScene
@export var spawnObj_2:PackedScene

@onready var spawnObjArray = [spawnObj_0, spawnObj_1, spawnObj_2]
@onready var hotspotArray = [$CounterHotspot, $CounterHotspot2, $CounterHotspot3]

func _ready():
	if spawnObjArray.size() == 3 and hotspotArray.size() == spawnObjArray.size():
		for index in spawnObjArray.size():
			if spawnObjArray[index] != null:
				var spawn_obj = spawnObjArray[index].instantiate()
				spawn_obj.position = hotspotArray[index].global_position
				spawn_obj.rotation = hotspotArray[index].global_rotation
				spawn_obj.obj_attached_to = hotspotArray[index]
				hotspotArray[index].currentItem = spawn_obj
				get_node("/root/Node3D").add_child.call_deferred(spawn_obj)
