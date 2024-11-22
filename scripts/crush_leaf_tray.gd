extends Area3D

@export var item_type = "leaf_tray"
@export var ingredient_on_spawn:Constants.ingredients = Constants.ingredients.GREEN_TEA

@onready var ingredients:Ingredients = $Blend.ingredients

var obj_attached_to = null

signal state_changed(state_text)

func _ready():
	ingredients.ingredients_changed.connect(on_ingredients_changed)

	if ingredient_on_spawn != null and !ingredients.add_ingredient(ingredient_on_spawn):
		print_debug("Failed to add spawn ingredient to " + item_type)

func onUseItem(target_item):
	if "machine_type" not in target_item:
		return false
	
	match target_item.machine_type:
		"oxidizer":
			# Replace with dequeue, have the player listen for the node being freed
			get_node("/root/Node3D/Player").destroy_held_item()
			return true
		_:
			return false

func on_ingredients_changed(_new_ingredient_list):
	state_changed.emit(getName())

func getName():
	return item_type
