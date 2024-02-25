class_name Constants

enum ingredients {
	NONE,
	GREEN_TEA,
	BLACK_TEA,
	ORANGE_PEEL,
	HIBISCUS,
	PINE_NEEDLE
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
	ingredients.ORANGE_PEEL: flavors.FRUITY,
	ingredients.HIBISCUS: flavors.FLORAL,
	ingredients.PINE_NEEDLE: flavors.EARTHY
}
