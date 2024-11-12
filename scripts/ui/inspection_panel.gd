extends PanelContainer

@onready var name_label = $MarginContainer/VBoxContainer/NameLabel
@onready var state_label = $MarginContainer/VBoxContainer/StateLabel
@onready var ingredients_label = $MarginContainer/VBoxContainer/IngredientsLabel

signal name_changed(name_text)
signal state_changed(state_text)
signal ingredients_changed(ingredient_text)

func _ready():
	name_changed.connect(name_label.onLabelUpdate)
	state_changed.connect(state_label.onLabelUpdate)
	ingredients_changed.connect(ingredients_label.onLabelUpdate)

func on_lookat_changed(target):
	visible = "item_type" in target

	name_changed.emit(target.item_type if "item_type" in target else "")
	name_label.visible = "item_type" in target
	
	state_changed.emit(target.state if "state" in target else "")
	state_label.visible = "state" in target

	if "ingredients" in target:
		ingredients_changed.emit(target.ingredients.ingredientsToString())
		ingredients_label.visible = target.ingredients.ingredients.size() > 0
	else:
		ingredients_changed.emit("")
		ingredients_label.visible = false
