class_name HotspotSpawner

func _init():
	pass

func SpawnHotspotObjects(spawnObjs, hotspots, spawnTeas):
	# Validate args
	if spawnObjs == null:
		printerr("HotspotSpawner: spawnObjs is null")
		return
	if hotspots == null:
		printerr("HotspotSpawner: hotspots is null")
		return
	if spawnObjs.size() != hotspots.size():
		printerr("HotspotSpawner: mismatch in size between spawnObjs and hotspots")
		return
	
	# Spawn objects on their hotspots
	for index in spawnObjs.size():
		if spawnObjs[index] != null and hotspots[index] != null:
			hotspots[index].spawn_requested.emit(
				spawnObjs[index].instantiate(),
				spawnTeas[index] if spawnTeas != null else Constants.ingredients.NONE
			)
