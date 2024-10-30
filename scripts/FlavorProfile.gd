class_name FlavorProfile

var flavors = [0, 0, 0, 0, 0, 0]

func _init(flavorProfile):
	addFlavorArray(flavorProfile)

func addIngredient(ingredient):
	addFlavorArray(Constants.ingredientFlavorMap[ingredient])

func addFlavorArray(flavorProfile):
	if flavorProfile == null or flavorProfile.size() == flavors.size():
		for flavorIndex in flavorProfile.size():
			flavors[flavorIndex] += flavorProfile[flavorIndex]

func setFlavorProfile(flavorProfile):
	for flavorIndex in flavorProfile.size():
			flavors[flavorIndex] += flavorProfile[flavorIndex]

func clearFlavorProfile():
	flavors = [0, 0, 0, 0, 0, 0]

func getFlavorMagnitude():
	return compareFlavorProfiles([0, 0, 0, 0, 0, 0])

func compareFlavorProfiles(flavor_profile):
	var total_delta = 0
	for index in flavors.size():
		total_delta += absi(flavor_profile.flavors[index] - flavors[index])
	return total_delta

func _to_string():
	var newText = ""
	newText += "grassy: " + str(flavors[0]) + "\n"
	newText += "floral: " + str(flavors[1]) + "\n"
	newText += "fruity: " + str(flavors[2]) + "\n"
	newText += "earthy: " + str(flavors[3]) + "\n"
	newText += "smoky: " + str(flavors[4]) + "\n"
	return newText

func _to_amount_string():
	var newText = ""
	for flavorIndex in flavors.size():
		for n in flavors[flavorIndex]:
			newText += n.to_string()
	return newText
