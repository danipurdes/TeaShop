class_name Constants

enum ingredients {
	NONE,
	GREEN_TEA,
	BLACK_TEA,
	ORANGE,
	HIBISCUS,
	DIRT
}

enum flavors {
	NONE,
	GRASSY,
	FLORAL,
	FRUITY,
	EARTHY,
	SMOKY
}

static var ingredientFlavorMap = {
	ingredients.GREEN_TEA: flavors.GRASSY,
	ingredients.BLACK_TEA: flavors.SMOKY,
	ingredients.ORANGE: flavors.FRUITY,
	ingredients.HIBISCUS: flavors.FLORAL,
	ingredients.DIRT: flavors.EARTHY
}
