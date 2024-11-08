extends Area3D

@export var item_type = "dispenser"
@export var tea: Constants.ingredients
@onready var ingredients = Ingredients.new()

var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.ingredients_changed.connect(onIngredientsChanged)
	ingredients.ingredients_changed.connect($Label.onLabelUpdate)
	state_changed.connect($Label.onLabelUpdate)
	ingredients.flavors_changed.connect($FlavorProfileUI.onLabelUpdate)
	if tea != null:
		ingredients.clearIngredients()
		ingredients.addIngredient(tea)

func useItem(heldItem):
	if heldItem == null or !heldItem.has_method("onUseItem"):
		return false
	if !heldItem.onUseItem(self):
		return false
		
	match heldItem.item_type:
		"tea_brick":
			return tryGiveContents(heldItem)
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

func onUseItem(itemToUseOn):
	if "item_type" not in itemToUseOn:
		return false
	
	match itemToUseOn.item_type:
		"tea_brick":
			return tryGiveContents(itemToUseOn)
		_:
			return false

func onIngredientsChanged(new_ingredients):
	$Label.visible = (new_ingredients.size() == 0)

func getName():
	return ingredients.ingredientsToString() + " dispenser"
