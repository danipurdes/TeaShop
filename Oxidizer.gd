extends Area3D

signal on_oxidize_enter
signal on_oxidize_exit
signal harvested_green
signal harvested_black

@export var tea_type = "none"
@export var idle_material: Material
@export var started_material: Material
@export var green_material: Material
@export var black_material: Material
@export var obj_green_tea_brick: PackedScene
@export var obj_black_tea_brick: PackedScene

func _ready():
	pass

func _process(_delta):
	pass

func ping():
	match tea_type:
		"none":
			if get_node("/root/Node3D").crush_leaf_count > 0:
				startOxidizeLeaves()
		"green":
			harvested_green.emit()
			stopOxidizeLeaves()
		"black":
			harvested_black.emit()
			stopOxidizeLeaves()

func startOxidizeLeaves():
	$GreenTeaTimer.start()
	tea_type = "started"
	on_oxidize_enter.emit()

func stopOxidizeLeaves():
	spawnTeaBrick()
	updateTeaType("none")
	$GreenTeaTimer.stop()
	$BlackTeaTimer.stop()
	on_oxidize_exit.emit()

func _on_green_tea_timer_timeout():
	updateTeaType("green")
	$BlackTeaTimer.start()

func _on_black_tea_timer_timeout():
	updateTeaType("black")

func updateTeaType(new_type):
	tea_type = new_type
	match tea_type:
		"none":
			$OxidizerIndicator.set_surface_override_material(0, idle_material)
		"started":
			$OxidizerIndicator.set_surface_override_material(0, started_material)
		"green":
			$OxidizerIndicator.set_surface_override_material(0, green_material)
		"black":
			$OxidizerIndicator.set_surface_override_material(0, black_material)

func spawnTeaBrick():
	print_debug(tea_type)
	match tea_type:
		"green":
			var newTeaBrick = obj_green_tea_brick.instantiate()
			newTeaBrick.position = $TeaBrickSpawn.global_position
			get_node("/root/Node3D").add_child(newTeaBrick)
		"black":
			var newTeaBrick = obj_black_tea_brick.instantiate()
			newTeaBrick.position = $TeaBrickSpawn.global_position
			get_node("/root/Node3D").add_child(newTeaBrick)
