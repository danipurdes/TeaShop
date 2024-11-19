extends Area3D

@export var item_type:String = "teacup"
@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.NONE

@onready var ingredients:Ingredients = Ingredients.new()

var state:String = "empty"
var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.ingredients_changed.connect(onIngredientsChanged)
	ingredients.flavors_changed.connect($FlavorProfileUI.onLabelUpdate)

	onIngredientsChanged(ingredients.ingredients)

func useItem(held_item):
	if held_item == null:
		return true
	if "item_type" not in held_item:
		return false
	
	match(held_item.item_type):
		"kettle":
			return useKettle(held_item)
		"teapot":
			return useTeapot(held_item)
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
	for ingredient in teapot.ingredients.ingredients:
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
			return true
		_:
			ingredients.clearIngredients()
			updateState("empty")
			return true

func updateState(new_state):
	if new_state == state:
		return
	
	state = new_state
	$Steam.emitting = (state == "hot_water")
	state_changed.emit(getName())

func onIngredientsChanged(new_ingredients):
	$IngredientMesh.visible = new_ingredients.size() > 0
	$IngredientMesh.set_surface_override_material(0, ingredients.ingredientsMat)
	state_changed.emit(getName())

func getName():
	return state
