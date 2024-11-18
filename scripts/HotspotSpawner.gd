class_name HotspotSpawner

func SpawnHotspotObjects(objs_to_spawn, hotspots, ingredients_to_spawn, allow_list):
	# Validate args
	if objs_to_spawn == null:
		printerr("HotspotSpawner: spawnObjs is null")
		return
	if hotspots == null:
		printerr("HotspotSpawner: hotspots is null")
		return
	if objs_to_spawn.size() != hotspots.size():
		printerr("HotspotSpawner: size mismatch between objs_to_spawn and hotspots")
	
	if ingredients_to_spawn != null and objs_to_spawn.size() != ingredients_to_spawn.size():
		printerr("HotspotSpawner: mismatch in size between objs_to_spawn and ingredients_to_spawn")
		return
	
	# Spawn objects on their hotspots
	for index in objs_to_spawn.size():
		if objs_to_spawn[index] == null or hotspots[index] == null:
			continue

		hotspots[index].spawn_requested.emit(
			objs_to_spawn[index].instantiate(),
			ingredients_to_spawn[index] if ingredients_to_spawn != null else Constants.ingredients.NONE,
			allow_list
		)
