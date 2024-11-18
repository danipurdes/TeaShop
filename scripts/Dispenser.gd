extends Area3D

@export var item_type:String = "dispenser"
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
	$IngredientLabel.visible = new_ingredients.size() > 0
	$IngredientLabel.onLabelUpdate(ingredients.ingredientsToString())
	$IngredientMesh.set_surface_override_material(0, ingredients.ingredientsMat)

func getName():
	return ingredients.ingredientsToString()
