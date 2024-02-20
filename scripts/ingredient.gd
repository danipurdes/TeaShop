extends Area3D

@export var item_type = "ingredient"
@export var ingredient: Constants.ingredients;
@export var mat_green_tea: Material
@export var mat_black_tea: Material
var flavor_profile = FlavorProfile.new()

func _ready():
	flavor_profile.addIngredient(ingredient)
	updateLabel()

func onUseItem(pinger):
	if "item_type" in pinger and pinger.item_type == "tea_brick":
		pinger.addIngredient(ingredient)
		get_node("/root/Node3D/Player").destroyHeldItem()
		updateLabel()
		return true
	return false

func setIngredient(newIngredient):
	ingredient = newIngredient
	flavor_profile.clearFlavorProfile()
	flavor_profile.addIngredient(ingredient)
	updateLabel()

func updateLabel():
	$Label.text = getName()

func getName():
	return Constants.ingredients.keys()[ingredient] + " ("+ item_type + ")\n" + flavor_profile._to_string()
