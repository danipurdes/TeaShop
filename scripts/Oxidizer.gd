extends StaticBody3D

signal on_oxidize_enter
signal on_oxidize_exit

@export var machine_type = "oxidizer"
var tea = Constants.ingredients.NONE
var state = "idle"
@onready var indicator_mat = StandardMaterial3D.new()
@export var idle_material: Material
@export var started_material: Material
@export var obj_ingredient: PackedScene

func _ready():
	updateStatusLabel("Inactive")
	$IndicatorMesh.set_surface_override_material(0, idle_material)

func useItem(item):
	if item == null:
		match state:
			"started":
				match tea:
					Constants.ingredients.GREEN_TEA:
						stopOxidizeLeaves()
						return true
					Constants.ingredients.BLACK_TEA:
						stopOxidizeLeaves()
						return true
		return false
	elif item.has_method("onUseItem") and item.onUseItem(self):
		if "item_type" in item and item.item_type == "leaf_tray":
			startOxidizeLeaves()
			return true
	return false

func startOxidizeLeaves():
	$GreenTeaTimer.start()
	state = "started"
	updateTeaType(Constants.ingredients.NONE)

func stopOxidizeLeaves():
	spawnTeaBrick()
	state = "idle"
	updateTeaType(Constants.ingredients.NONE)
	$ParticleEmitter.emitting = true
	$GreenTeaTimer.stop()
	$BlackTeaTimer.stop()

func _on_green_tea_timer_timeout():
	updateTeaType(Constants.ingredients.GREEN_TEA)
	$BlackTeaTimer.start()

func _on_black_tea_timer_timeout():
	updateTeaType(Constants.ingredients.BLACK_TEA)

func updateTeaType(new_type):
	tea = new_type
	match state:
		"idle":
			$IndicatorMesh.set_surface_override_material(0, idle_material)
			updateStatusLabel("Inactive")
		"started":
			match tea:
				Constants.ingredients.GREEN_TEA:
					updateMaterial(Constants.ingredients.GREEN_TEA)
					updateStatusLabel("Green Tea")
				Constants.ingredients.BLACK_TEA:
					updateMaterial(Constants.ingredients.BLACK_TEA)
					updateStatusLabel("Black Tea")
				_:
					$IndicatorMesh.set_surface_override_material(0, started_material)
					updateStatusLabel("Working")

func updateMaterial(e_ingredient):
	indicator_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	var color_ingredient = Constants.ingredientColorMap[e_ingredient]
	indicator_mat.albedo_color = color_ingredient
	$IndicatorMesh.set_surface_override_material(0, indicator_mat)

func spawnTeaBrick():
	if tea != Constants.ingredients.NONE:
		var newTeaBrick = obj_ingredient.instantiate()
		if "tea" in newTeaBrick:
			newTeaBrick.tea = tea
		get_node("/root/Node3D").add_child(newTeaBrick)
		newTeaBrick.position = $TeaBrickSpawn.global_position

func updateStatusLabel(new_status):
	$TeaLabel.text = new_status
