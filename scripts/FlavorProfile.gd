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

func getFlavorMagnitude():
	return grassy + floral + fruity + earthy + smoky + caffeine

func compareFlavorProfiles(flavor_profile):
	var source_flavors = toArray()
	var input_flavors = flavor_profile.toArray()
	var total_delta = 0
	
	for index in source_flavors.size():
		total_delta += absi(input_flavors[index] - source_flavors[index])
	
	return total_delta

func _to_string():
	return "grassy: " + str(grassy) + "\n" + "floral: " + str(floral) + "\n" + "fruity: " + str(fruity) + "\n" + "earthy: " + str(earthy) + "\n" + "smoky: " + str(smoky)

func _to_amount_string():
	var newText = ""
	for n in grassy:
		newText += "0"
	for n in floral:
		newText += "1"
	for n in fruity:
		newText += "2"
	for n in earthy:
		newText += "3"
	for n in smoky:
		newText += "4"
	return newText

func toArray():
	return [grassy, floral, fruity, earthy, smoky, caffeine]
