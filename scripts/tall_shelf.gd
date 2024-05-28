extends StaticBody3D

@export var spawnObj_0_0:PackedScene
@export var spawnObj_0_1:PackedScene
@export var spawnObj_1_0:PackedScene
@export var spawnObj_1_1:PackedScene
@export var spawnObj_2_0:PackedScene
@export var spawnObj_2_1:PackedScene

@onready var spawnObjArray = [spawnObj_0_0, spawnObj_0_1, spawnObj_1_0, spawnObj_1_1, spawnObj_2_0, spawnObj_2_1]
@onready var hotspotArray = [$CounterHotspot, $CounterHotspot2, $CounterHotspot3, $CounterHotspot4, $CounterHotspot5, $CounterHotspot6]

func _ready():
	if spawnObjArray.size() == 6 and hotspotArray.size() == spawnObjArray.size():
		for index in spawnObjArray.size():
			if spawnObjArray[index] != null:
				var spawn_obj = spawnObjArray[index].instantiate()
				spawn_obj.position = hotspotArray[index].global_position
				spawn_obj.rotation = hotspotArray[index].global_rotation
				spawn_obj.obj_attached_to = hotspotArray[index]
				hotspotArray[index].currentItem = spawn_obj
				get_node("/root/Node3D").add_child.call_deferred(spawn_obj)
