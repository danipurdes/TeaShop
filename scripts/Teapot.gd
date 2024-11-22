extends Area3D

@export var item_type:String = "teapot"
@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.NONE
@export_range(1,10) var servings_max = 3

@onready var ingredients:Ingredients = $Blend.ingredients

var state:String = "empty"
var servings_current:int = 0
var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.flavors_changed.connect($FlavorProfileUI.on_flavors_changed)

	if ingredient_on_spawn != null and !ingredients.add_ingredient(ingredient_on_spawn):
		print_debug("Failed to add spawn ingredient to " + item_type)

func useItem(held_item):
	if held_item == null:
		return true
	if "item_type" not in held_item:
		return false
	
	match held_item.item_type:
		"kettle":
			return use_kettle(held_item)
		"tea_brick":
			return held_item.onUseItem(self)
		_:
			return false

func onUseItem(target_item):
	if "machine_type" in target_item:
		match target_item.machine_type:
			"sink":
				return use_on_sink()
			_:
				return false
	
	if "item_type" in target_item:
		match target_item.item_type:
			"teacup":
				return use_on_teacup(target_item)
			_:
				return false
	
	return false

func use_kettle(kettle):
	match kettle.state:
		"empty":
			return false
		_:
			match state:
				"empty":
					update_state(kettle.state)
					update_servings(kettle.servings_current)
					return true
				_:
					return false

func use_on_sink():
	match state:
		"empty":
			update_state("cold_water")
			update_servings(servings_max)
		_:
			update_servings(0)
	return true

func use_on_teacup(teacup):
	if servings_current <= 0:
		return false
	
	if teacup.ingredients.add_ingredients(ingredients):
		update_servings(servings_current - 1)
		return true
	return false

func update_state(new_state):
	if new_state == state:
		return
	state = new_state
	$Steam.emitting = (state == "hot_water")
	state_changed.emit(getName())

func update_servings(new_servings):
	if servings_current == new_servings:
		return
	servings_current = new_servings
	if servings_current <= 0:
		ingredients.clearIngredients()
		update_state("empty")

func getName():
	return str(servings_current) + "/" + str(servings_max)
