extends PanelContainer

@onready var name_label = $MarginContainer/VBoxContainer/NameLabel
@onready var state_label = $MarginContainer/VBoxContainer/StateLabel
@onready var ingredients_label = $MarginContainer/VBoxContainer/IngredientsLabel

signal name_changed(name_text)
signal state_changed(state_text)
signal ingredients_changed(ingredient_text)

func _ready():
	name_changed.connect(name_label.on_label_update)
	state_changed.connect(state_label.on_label_update)
	ingredients_changed.connect(ingredients_label.on_label_update)

func on_target_changed(target):
	if target == null:
		visible = false
		return

	# Name
	var new_name_label = get_name_label(target)
	name_changed.emit(new_name_label)
	name_label.visible = new_name_label != ""
	
	# State
	var new_state_label = target.state if "state" in target else ""
	state_changed.emit(new_state_label)
	state_label.visible = new_state_label != ""

	# Ingredients
	var new_ingredients_label = get_ingredients_label(target)
	ingredients_changed.emit(new_ingredients_label)
	ingredients_label.visible = new_ingredients_label != ""
	
	# Panel visibility
	var any_labels_visible = name_label.visible or state_label.visible or ingredients_label.visible
	visible = any_labels_visible

func get_name_label(target):
	if "item_type" not in target and "machine_type" not in target:
		return ""
	
	var output = ""
	if "item_type" in target:
		output += target.item_type
	elif "machine_type" in target:
		output += target.machine_type
	
	if target.has_method("servings_to_string"):
		output += " ("
		output += target.servings_to_string()
		output += ")"
	return output

func get_ingredients_label(target):
	if "ingredients" not in target:
		return ""
	
	return target.ingredients.ingredients_to_string()