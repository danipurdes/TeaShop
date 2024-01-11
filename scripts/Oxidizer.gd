extends Area3D

signal on_oxidize_enter
signal on_oxidize_exit

@export var machine_type = "oxidizer"
@export var tea = Constants.tea_type.NONE
@export var state = "idle"
@export var idle_material: Material
@export var started_material: Material
@export var green_material: Material
@export var black_material: Material
@export var obj_tea_brick: PackedScene

func ping():
	match state:
		"started":
			match tea:
				Constants.tea_type.GREEN_TEA:
					stopOxidizeLeaves()
					return true
				Constants.tea_type.BLACK_TEA:
					stopOxidizeLeaves()
					return true
	return false

func useItem(item):
	if item.has_method("onUseItem") and item.onUseItem(self):
		if "item_type" in item and item.item_type == "leaf_tray":
			startOxidizeLeaves()
			return true
	return false

func startOxidizeLeaves():
	$GreenTeaTimer.start()
	state = "started"

func stopOxidizeLeaves():
	spawnTeaBrick()
	state = "idle"
	updateTeaType(Constants.tea_type.NONE)
	$GreenTeaTimer.stop()
	$BlackTeaTimer.stop()

func _on_green_tea_timer_timeout():
	updateTeaType(Constants.tea_type.GREEN_TEA)
	$BlackTeaTimer.start()

func _on_black_tea_timer_timeout():
	updateTeaType(Constants.tea_type.BLACK_TEA)

func updateTeaType(new_type):
	tea = new_type
	match state:
		"idle":
			$IndicatorMesh.set_surface_override_material(0, idle_material)
		"started":
			match tea:
				Constants.tea_type.GREEN_TEA:
					$IndicatorMesh.set_surface_override_material(0, green_material)
				Constants.tea_type.BLACK_TEA:
					$IndicatorMesh.set_surface_override_material(0, black_material)
				_:
					$IndicatorMesh.set_surface_override_material(0, started_material)

func spawnTeaBrick():
	if tea != Constants.tea_type.NONE:
		var newTeaBrick = obj_tea_brick.instantiate()
		newTeaBrick.setTea(tea)
		newTeaBrick.position = $TeaBrickSpawn.global_position
		get_node("/root/Node3D").add_child(newTeaBrick)
