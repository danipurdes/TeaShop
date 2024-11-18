extends Area3D

@export var item_type:String = "teapot"
@export_range(1,10) var servings_max = 3

@onready var ingredients = Ingredients.new()

var state:String = "empty"
var servings_current:int = 0
var obj_attached_to = null

signal state_changed(new_state)

func _ready():
	ingredients.flavors_changed.connect($FlavorProfileUI.onLabelUpdate)

func useItem(held_item):
	if held_item == null:
		return false
	if "item_type" not in held_item:
		return false
	
	match held_item.item_type:
		"kettle":
			return useKettle(held_item)
		"tea_brick":
			return held_item.onUseItem(self)
		_:
			return false

func onUseItem(item_to_use_on):
	if "machine_type" in item_to_use_on:
		match item_to_use_on.machine_type:
			"sink":
				return useOnSink()
			_:
				return false
	
	if "item_type" in item_to_use_on:
		match item_to_use_on.item_type:
			"teacup":
				return useOnTeacup(item_to_use_on)
			_:
				return false
	
	return false

func useKettle(kettle):
	match kettle.state:
		"empty":
			return false
		_:
			match state:
				"empty":
					update_state(kettle.state)
					update_servings(kettle.servings_current)
					kettle.update_servings(0)
					return true
				_:
					return false

func useOnSink():
	match state:
		"empty":
			update_state("cold_water")
			update_servings(servings_max)
		_:
			update_servings(0)
	return true

func useOnTeacup(teacup):
	if servings_current <= 0:
		return false
	if teacup.ingredients.ingredients.size() + ingredients.ingredients.size() > teacup.ingredients.max_ingredients:
		return false

	for ingredient in ingredients.ingredients:
		teacup.ingredients.addIngredient(ingredient)
	update_servings(servings_current - 1)
	
	return true

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
