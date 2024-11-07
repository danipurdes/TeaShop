extends Area3D

@export var item_type = "teacup"
@export var state = "empty"
@onready var ingredients = Ingredients.new()

var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.ingredients_changed.connect(onIngredientsChanged)
	ingredients.ingredients_changed.connect($Label.onLabelUpdate)
	state_changed.connect($Label.onLabelUpdate)
	ingredients.flavors_changed.connect($FlavorProfileUI.onLabelUpdate)

	onIngredientsChanged(ingredients.ingredients)

func useItem(heldItem):
	if heldItem == null:
		return true
	if "item_type" not in heldItem:
		return false
	
	match(heldItem.item_type):
		"teakettle":
			return useKettle(heldItem)
		"teapot":
			return useTeapot(heldItem)
		_:
			return false

func useKettle(kettle):
	if kettle.state == "empty" or state != "empty":
		return false

	updateState(kettle.state)
	kettle.updateState("empty")
	return true

func useTeapot(teapot):
	if teapot.state == "empty" or state != "empty":
		return false
	
	var newIngredientCount = teapot.ingredients.ingredients.size() + ingredients.ingredients.size()
	if newIngredientCount > ingredients.max_ingredients:
		return false
	
	updateState(teapot.state)
	for ingredient in teapot.ingredientList:
		ingredients.addIngredient(ingredient)
	return true

func onUseItem(itemToUseOn):
	if "machine_type" not in itemToUseOn:
		return false

	match itemToUseOn.machine_type:
		"sink":
			return useOnSink()
		_:
			return false

func useOnSink():
	match state:
		"empty":
			updateState("cold_water")
		_:
			ingredients.clearIngredients()
			updateState("empty")
	return true

func updateState(new_state):
	state = new_state
	$Steam.emitting = (state == "hot_water")
	state_changed.emit(getName())
	$Label.visible = (state != "empty")

func onIngredientsChanged(_new_ingredients):
	$tea_cup/tea_cup_liquid.set_surface_override_material(0, ingredients.ingredientsMat)

func getName():
	return state
