class_name Constants

enum ingredients {
	NONE,
	GREEN_TEA,
	BLACK_TEA,
	ORANGE_PEEL,
	HIBISCUS,
	PINE_NEEDLE,
}

enum flavors {
	NONE,
	GRASSY,
	FLORAL,
	FRUITY,
	EARTHY,
	SMOKY,
}

static var ingredientFlavorMap = {
	ingredients.NONE: [0,0,0,0,0,0],
	ingredients.GREEN_TEA: [1,0,0,0,0,1],
	ingredients.BLACK_TEA: [0,0,0,0,1,1],
	ingredients.ORANGE_PEEL: [0,0,1,0,0,0],
	ingredients.HIBISCUS: [0,1,0,0,0,0],
	ingredients.PINE_NEEDLE: [0,0,0,1,0,0],
}

static var ingredientColorMap = {
	ingredients.NONE: Color(0.1,0.1,0.1,0.1),
	ingredients.GREEN_TEA: Color.DARK_GREEN,
	ingredients.BLACK_TEA: Color.WEB_MAROON,
	ingredients.ORANGE_PEEL: Color.DARK_ORANGE,
	ingredients.HIBISCUS: Color.MEDIUM_VIOLET_RED,
	ingredients.PINE_NEEDLE: Color.ORANGE,
}
