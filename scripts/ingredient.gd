extends Area3D

# TODO: Deprecate in favor of tea_brick

@export var item_type = "ingredient"
@export var ingredient: Constants.ingredients;
@export var color_ingredient: Color
var flavor_profile = FlavorProfile.new(0,0,0,0,0,0)
var obj_attached_to = null

func _ready():
	flavor_profile.addIngredient(ingredient)
	updateMaterial()
	updateLabel()

func onUseItem(pinger):
	if "item_type" in pinger and pinger.item_type == "tea_brick":
		pinger.addIngredient(ingredient)
		flavor_profile.clearFlavorProfile()
		ingredient = Constants.ingredients.NONE
		updateMaterial()
		updateLabel()
		return true
	return false

func setIngredient(newIngredient):
	ingredient = newIngredient
	flavor_profile.clearFlavorProfile()
	flavor_profile.addIngredient(ingredient)
	updateLabel()

func updateMaterial():
	var ingredientMat = StandardMaterial3D.new()
	ingredientMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	color_ingredient = Constants.ingredientColorMap[ingredient]
	ingredientMat.albedo_color = color_ingredient
	$Mesh.set_surface_override_material(0, ingredientMat)

func updateLabel():
	$Label.text = getName()
	$ui_flavor_profile.updateLabel(flavor_profile)

func getName():
	return Constants.ingredients.keys()[ingredient] #+ "\n" + flavor_profile._to_string()
