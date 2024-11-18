extends Area3D

@export var item_type = "tea_brick"
@export var ingredient_on_spawn: Constants.ingredients = Constants.ingredients.NONE
@onready var ingredients = Ingredients.new()

var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.ingredients_changed.connect(onIngredientsChanged)
	ingredients.flavors_changed.connect($FlavorProfileUI.onLabelUpdate)
	
	match ingredient_on_spawn:
		Constants.ingredients.NONE:
			return
		_:
			ingredients.addIngredient(ingredient_on_spawn)

func useItem(held_item):
	if held_item == null:
		return true
	if !held_item.has_method("onUseItem"):
		return false
	return held_item.onUseItem(self)

func onUseItem(itemToUseOn):
	if "item_type" not in itemToUseOn:
		return false
		
	match itemToUseOn.item_type:
		"tea_brick":
			return tryGiveContents(itemToUseOn)
		"teapot":
			return tryGiveContents(itemToUseOn)
		"dispenser":
			return true
		_:
			return false

func tryGiveContents(vessel):
	if vessel.ingredients.ingredients.size() + ingredients.ingredients.size() > vessel.ingredients.max_ingredients:
		return false
	giveContents(vessel)
	return true

func giveContents(vessel):
	for ingredient in ingredients.ingredients:
		vessel.ingredients.addIngredient(ingredient)
	ingredients.clearIngredients()

func onIngredientsChanged(_new_ingredients):
	$IngredientMesh.set_surface_override_material(0, ingredients.ingredientsMat)
	state_changed.emit(getName())

func getName():
	return ingredients.ingredientsToString()
