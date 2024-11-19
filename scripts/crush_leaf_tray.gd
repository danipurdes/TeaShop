extends Area3D

@export var item_type = "leaf_tray"
@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.GREEN_TEA

@onready var ingredients = Ingredients.new()

var obj_attached_to = null

signal state_changed(state_text)

func _ready():
	ingredients.ingredients_changed.connect(onIngredientsChanged)

	match ingredient_on_spawn:
		Constants.ingredients.NONE:
			return
		_:
			ingredients.addIngredient(ingredient_on_spawn)

func onUseItem(item_to_use_on):
	if "machine_type" not in item_to_use_on:
		return false
	
	match item_to_use_on.machine_type:
		"oxidizer":
			get_node("/root/Node3D/Player").destroyHeldItem()
			return true
		_:
			return false

func onIngredientsChanged(_new_ingredients):
	$IngredientMesh.set_surface_override_material(0, ingredients.ingredientsMat)
	state_changed.emit(getName())

func getName():
	return item_type
