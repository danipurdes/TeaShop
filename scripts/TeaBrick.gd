extends Area3D

@export var item_type:String = "tea_brick"
@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.NONE

@onready var ingredients:Ingredients = $BlendAnchor/Blend.ingredients

var state:String = "empty"
var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.ingredients_changed.connect(on_ingredients_changed)
	ingredients.flavors_changed.connect($FlavorProfileUI.on_flavors_changed)
	
	if ingredient_on_spawn != null and !ingredients.add_ingredient(ingredient_on_spawn):
		print_debug("Failed to add spawn ingredient to " + item_type)

func useItem(held_item):
	if held_item == null:
		return true
	if !held_item.has_method("onUseItem"):
		return false
	return held_item.onUseItem(self)

func onUseItem(target_item):
	if "item_type" not in target_item:
		return false
		
	match target_item.item_type:
		"tea_brick":
			if "ingredients" not in target_item:
				return false
			return ingredients.transfer_ingredients(target_item.ingredients)
		"teapot":
			if "ingredients" not in target_item:
				return false
			return ingredients.transfer_ingredients(target_item.ingredients)
		"dispenser":
			return true
		_:
			return false

func on_ingredients_changed(new_ingredient_list):
	$BlendAnchor.scale.y = new_ingredient_list.size()
	if new_ingredient_list.is_empty():
		update_state("empty")
		return
	if new_ingredient_list.size() == ingredients.ingredient_count_max:
		update_state("full")
		return
	update_state("partial")

func update_state(new_state):
	if new_state == state:
		return
	state = new_state
	state_changed.emit(getName())

func getName():
	return ingredients.ingredients_to_string()
