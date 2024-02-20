class_name FlavorProfile

var grassy = 0
var floral = 0
var fruity = 0
var earthy = 0
var smoky = 0

func addIngredient(ingredient):
	match Constants.ingredientFlavorMap[ingredient]:
		Constants.flavors.GRASSY:
			grassy += 1
		Constants.flavors.FLORAL:
			floral += 1
		Constants.flavors.FRUITY:
			fruity += 1
		Constants.flavors.EARTHY:
			earthy += 1
		Constants.flavors.SMOKY:
			smoky += 1

func addFlavorProfile(flavorProfile):
	grassy += flavorProfile.grassy
	floral += flavorProfile.floral
	fruity += flavorProfile.fruity
	earthy += flavorProfile.earthy
	smoky += flavorProfile.smoky

func copyFlavorProfile(flavorProfile):
	grassy = flavorProfile.grassy
	floral = flavorProfile.floral
	fruity = flavorProfile.fruity
	earthy = flavorProfile.earthy
	smoky = flavorProfile.smoky

func clearFlavorProfile():
	grassy = 0
	floral = 0
	fruity = 0
	earthy = 0
	smoky = 0

func _to_string():
	return "grassy: " + str(grassy) + "\n" + "floral: " + str(floral) + "\n" + "fruity: " + str(fruity) + "\n" + "earthy: " + str(earthy) + "\n" + "smoky: " + str(smoky)
