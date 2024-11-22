extends Area3D

@export var item_type:String = "teacup"
@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.NONE

@onready var ingredients:Ingredients = $Blend.ingredients

var state:String = "empty"
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
	
	match(held_item.item_type):
		"kettle":
			return use_kettle(held_item)
		"teapot":
			return use_teapot(held_item)
		_:
			return false

func use_kettle(kettle):
	match kettle.state:
		"empty":
			return false
		_:
			match state:
				"empty":
					update_state(kettle.state)
					return true
				_:
					return false

func use_teapot(teapot):
	if teapot.state == "empty" or state != "empty":
		return false
	if !teapot.has_method("onUseItem"):
		return false
	
	var new_state = teapot.state
	if !teapot.onUseItem(self):
		return false
	update_state(new_state)
	return true

func onUseItem(target_item):
	if "machine_type" not in target_item:
		return false

	match target_item.machine_type:
		"sink":
			return use_on_sink()
		_:
			return false

func use_on_sink():
	match state:
		"empty":
			update_state("cold_water")
			return true
		_:
			ingredients.clear_ingredients()
			update_state("empty")
			return true

func update_state(new_state):
	if new_state == state:
		return
	state = new_state
	$Steam.emitting = (state == "hot_water")
	state_changed.emit(getName())

func on_ingredients_changed(_new_ingredient_list):
	state_changed.emit(getName())

func getName():
	return state
