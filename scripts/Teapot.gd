extends Area3D

@export var item_type = "teapot"
@export var state = "empty"
@export var max_servings = 3
@onready var ingredients = Ingredients.new()

var obj_attached_to = null
var servings = 0

signal state_changed(newState)

func _ready():
	ingredients.ingredients_changed.connect($Label.onLabelUpdate)
	state_changed.connect($Label.onLabelUpdate)
	ingredients.flavors_changed.connect($FlavorProfileUI.onLabelUpdate)

func useItem(heldItem):
	if heldItem == null:
		return true
	if "item_type" not in heldItem:
		return false
	
	match (heldItem.item_type):
		"teakettle":
			return useKettle(heldItem)
		"tea_brick":
			return useTeaJar(heldItem)
		_:
			return false

func onUseItem(pinger):
	if "machine_type" in pinger and pinger.machine_type == "sink":
		return useOnSink()
	if "item_type" in pinger and pinger.item_type == "teacup":
		return useOnTeacup(pinger)
	return false

func useKettle(kettle):
	match kettle.state:
		"hot_water":
			match state:
				"empty":
					updateState("hot_water")
					kettle.updateState("empty")
					updateServings(max_servings)
					return true
				_:
					return false
		_:
			return false

func useTeaJar(teajar):
	var newIngredientCount = teajar.ingredients.ingredients.length + ingredients.ingredients.length
	if newIngredientCount > ingredients.max_ingredients:
		return false

	# store tea jar ingredients because they get cleared
	var teajar_ingredients = teajar.ingredients.ingredients.duplicate()
	if !teajar.onUseItem(self):
		return false

	for ingredient in teajar_ingredients:
		ingredients.addIngredient(ingredient)
	return true

func useOnSink():
	match state:
		"empty":
			updateState("cold_water")
		_:
			updateState("empty")
			ingredients.clearIngredients()
			updateServings(0)
	return true

func useOnTeacup(teacup):
	if servings <= 0:
		return false
	
	if teacup.ingredients.ingredients.length + ingredients.ingredients.length > teacup.ingredients.max_ingredients:
		return false

	updateServings(servings - 1)
	for ingredient in ingredients:
		teacup.ingredients.addIngredient(ingredient)
	return true

func updateState(newState):
	state = newState
	$Steam.emitting = (state == "hot_water")
	state_changed.emit(getName())
	$Label.visible = (state != "empty")

func updateServings(newServings):
	servings = newServings
	if servings <= 0:
		ingredients.clearIngredients()
		updateState("empty")
	state_changed.emit(getName())	

func getName():
	return state + " servings: " + str(servings)
