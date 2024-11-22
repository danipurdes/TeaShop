extends MeshInstance3D

class_name Blend

@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.NONE
@export var ingredient_count_max = 5

@onready var ingredients:Ingredients = Ingredients.new(ingredient_count_max)

signal material_changed(new_material:StandardMaterial3D)

func _ready():
	ingredients.color_changed.connect(on_color_changed)
	set_surface_override_material(0, reset_material())

	if ingredient_on_spawn != null:
		ingredients.add_ingredient(ingredient_on_spawn)

func reset_material():
	var new_material = StandardMaterial3D.new()
	new_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	return new_material

func on_color_changed(new_color:Color):
	var new_material = get_surface_override_material(0)
	new_material.albedo_color = new_color
	set_surface_override_material(0, new_material)
	material_changed.emit(new_material)
