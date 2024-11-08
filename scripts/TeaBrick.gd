extends Area3D

@export var item_type = "tea_brick"
@export var tea: Constants.ingredients
@onready var ingredients = Ingredients.new()

var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.ingredients_changed.connect(onIngredientsChanged)
	state_changed.connect($Label.onLabelUpdate)
	ingredients.ingredients_changed.connect(getIngredientNames)
	ingredients.flavors_changed.connect($FlavorProfileUI.onLabelUpdate)
	if tea != null:
		ingredients.clearIngredients()
		ingredients.addIngredient(tea)

func useItem(heldItem):
	if heldItem == null:
		return true
	if !heldItem.has_method("onUseItem"):
		return false
	return heldItem.onUseItem(self)

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

func onIngredientsChanged(newIngredients):
	$IngredientMesh.set_surface_override_material(0, ingredients.ingredientsMat)
	$Label.visible = (newIngredients.size() != 0)
	state_changed.emit(getName())

func getIngredientNames():
	$Label.onLabelUpdate(getName())

func getName():
	return ingredients.ingredientsToString()
