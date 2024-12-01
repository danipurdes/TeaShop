extends Area3D

@export var item_type:String = "dispenser"
@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.NONE

@onready var ingredients:Ingredients = $Blend.ingredients

var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.ingredients_changed.connect(on_ingredients_changed)
	ingredients.flavors_changed.connect($FlavorProfileUI.on_flavors_changed)

	if ingredient_on_spawn != null and !ingredients.add_ingredient(ingredient_on_spawn):
		print_debug("Failed to add spawn ingredient to " + item_type)

func useItem(held_item):
	if held_item == null:
		return false
	if !held_item.has_method("onUseItem") or !held_item.onUseItem(self):
		return false
		
	match held_item.item_type:
		"jar":
			if "ingredients" not in held_item:
				return false
			return held_item.ingredients.add_ingredients(ingredients)
		_:
			return false

func onUseItem(target_item):
	if "item_type" not in target_item:
		return false
	
	match target_item.item_type:
		"jar":
			if "ingredients" not in target_item:
				return false
			return target_item.ingredients.add_ingredients(ingredients)
		_:
			return false

func on_ingredients_changed(_new_ingredients):
	$IngredientLabel.on_label_update(ingredients.ingredients_to_string())

func getName():
	return ingredients.ingredients_to_string()
