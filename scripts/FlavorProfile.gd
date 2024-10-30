class_name FlavorProfile

var flavors = [0, 0, 0, 0, 0, 0]

func _init(flavorArray):
	addFlavorArray(flavorArray)

func addIngredient(ingredient):
	var ingredientFlavorArray = Constants.ingredientFlavorMap[ingredient]
	print_debug(ingredientFlavorArray)
	addFlavorArray(ingredientFlavorArray)

func addFlavorArray(flavorArray):
	if flavorArray == null or flavorArray.size() != flavors.size():
		print_debug("addFlavorArray: flavorArray null or size mismatch")
		return
	
	print_debug("flavors: " + str(flavors))
	print_debug("flavorArray: " + str(flavorArray))
	for flavorIndex in flavorArray.size():
		flavors[flavorIndex] += flavorArray[flavorIndex]
	print_debug("new flavors: " + str(flavors))

func setFlavorProfile(flavorArray):
	if flavorArray == null or flavorArray.size() != flavors.size():
		print_debug("setFlavorArray: flavorProfile null or size mismatch")
		return
		
	flavors = flavorArray.duplicate()
	print_debug("flavors: " + flavors)
	print_debug("flavorArray: " + flavorArray)

func clearFlavorProfile():
	flavors.resize(6)
	flavors.fill(0)
	print_debug("flavors: " + str(flavors))

func getFlavorMagnitude():
	return compareFlavorArrays([0, 0, 0, 0, 0, 0])

func compareFlavorArrays(flavorArray):
	if flavorArray == null or flavorArray.size() != flavors.size():
		print_debug("compareFlavorProfiles: flavorArray null or size mismatch")
		return -1
	
	var total_delta = 0
	for index in flavors.size():
		var flavorDiff = absi(flavorArray[index] - flavors[index])
		print_debug("flavor " + str(index) + ": " + str(flavorDiff))
		total_delta += flavorDiff
	
	return total_delta

func _to_amount_string():
	var newText = ""
	for flavorIndex in flavors.size():
		for n in flavors[flavorIndex]:
			newText += str(flavorIndex)
	print_debug("flavors: " + str(flavors))
	print_debug("amount_string: " + newText)
	return newText
