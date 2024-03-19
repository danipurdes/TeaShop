class_name FlavorProfile

var grassy = 0
var floral = 0
var fruity = 0
var earthy = 0
var smoky = 0
var caffeine = 0

func _init(_grassy, _floral, _fruity, _earthy, _smoky, _caffeine):
	grassy = _grassy
	floral = _floral
	fruity = _fruity
	earthy = _earthy
	smoky = _smoky
	caffeine = _caffeine
	
func addIngredient(ingredient):
	addFlavorArray(Constants.ingredientFlavorMap[ingredient])

func addFlavorArray(flavorArray):
	if flavorArray != null and flavorArray.size() == 6:
		grassy += flavorArray[0]
		floral += flavorArray[1]
		fruity += flavorArray[2]
		earthy += flavorArray[3]
		smoky += flavorArray[4]
		caffeine += flavorArray[5]

func addFlavorProfile(flavorProfile):
	grassy += flavorProfile.grassy
	floral += flavorProfile.floral
	fruity += flavorProfile.fruity
	earthy += flavorProfile.earthy
	smoky += flavorProfile.smoky
	caffeine += flavorProfile.caffeine

func copyFlavorProfile(flavorProfile):
	grassy = flavorProfile.grassy
	floral = flavorProfile.floral
	fruity = flavorProfile.fruity
	earthy = flavorProfile.earthy
	smoky = flavorProfile.smoky
	caffeine = flavorProfile.caffeine

func clearFlavorProfile():
	grassy = 0
	floral = 0
	fruity = 0
	earthy = 0
	smoky = 0
	caffeine = 0

func _to_string():
	return "grassy: " + str(grassy) + "\n" + "floral: " + str(floral) + "\n" + "fruity: " + str(fruity) + "\n" + "earthy: " + str(earthy) + "\n" + "smoky: " + str(smoky)
