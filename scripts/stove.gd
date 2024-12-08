extends StaticBody3D

@export var allow_list:Array[String] = ["kettle"]
@export var spawnObj:PackedScene
@export var spawnTea:Constants.ingredients = Constants.ingredients.NONE

func _ready():
	$CounterHotspot.allow_list = allow_list
	if spawnObj != null:
		$CounterHotspot.spawnObject(
			spawnObj.instantiate(),
			spawnTea,
			allow_list
		)
	$CounterHotspot.object_placed.connect(heat_item)

func heat_item():
	var item_to_heat = $CounterHotspot.currentItem
	if "heatable" in item_to_heat and item_to_heat.heatable:
		match item_to_heat.state:
			"cold_water":
				item_to_heat.update_state("hot_water")
				$Boiling.play()
