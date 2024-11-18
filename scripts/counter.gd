extends StaticBody3D

@export var allow_list:Array[String] = []
@export var spawnObj:PackedScene
@export var spawnTea:Constants.ingredients = Constants.ingredients.NONE

func _ready():
	if spawnObj != null:
		$CounterHotspot.spawnObject(
			spawnObj.instantiate(),
			spawnTea,
			allow_list
		)
