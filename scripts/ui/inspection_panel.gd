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
	name_changed.emit(target.item_type if "item_type" in target else "")
	name_label.visible = "item_type" in target
	
	# State
	state_changed.emit(target.state if "state" in target else "")
	state_label.visible = "state" in target

	# Ingredients
	if "ingredients" in target:
		ingredients_changed.emit(target.ingredients.ingredients_to_string())
		ingredients_label.visible = target.ingredients.ingredient_list.size() > 0
	else:
		ingredients_changed.emit("")
		ingredients_label.visible = false
	
	# Panel visibility
	visible = "item_type" in target and (name_label.visible or state_label.visible or ingredients_label.visible)
