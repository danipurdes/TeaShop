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

func _ready():
	pass

func _process(_delta):
	pass

func ping():
	if tea_type == "none":
		if get_node("/root/Node3D").crush_leaf_count > 0:
			startOxidizeLeaves()
	if tea_type == "green":
		harvested_green.emit()
		stopOxidizeLeaves()
		print_debug("green ready")
	if tea_type == "black":
		harvested_black.emit()
		stopOxidizeLeaves()
		print_debug("black ready")

func startOxidizeLeaves():
	$GreenTeaTimer.start()
	tea_type = "started"
	on_oxidize_enter.emit()

func stopOxidizeLeaves():
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
	if tea_type == "none":
		$OxidizerIndicator.set_surface_override_material(0, idle_material)
	if tea_type == "started":
		$OxidizerIndicator.set_surface_override_material(0, started_material)
	if tea_type == "green":
		$OxidizerIndicator.set_surface_override_material(0, green_material)
	if tea_type == "black":
		$OxidizerIndicator.set_surface_override_material(0, black_material)
