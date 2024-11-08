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

enum fluid_state {
	NONE,
	COLD_WATER,
	HOT_WATER,
}

enum vessel_state {
	UNAVAILABLE,
	AVAILABLE
}

static var ingredientFlavorMap = {
	ingredients.NONE: [0,0,0,0,0,0],
	ingredients.GREEN_TEA: [1,0,0,0,0,0],
	ingredients.BLACK_TEA: [0,0,0,0,1,0],
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

static var ingredientMap = {
	ingredients.NONE: {
		"color": Color(0.1,0.1,0.1,0.1),
		"flavor": [0,0,0,0,0,0]
	},
	ingredients.GREEN_TEA: {
		"color": Color.DARK_GREEN,
		"flavor": [1,0,0,0,0,0]
	},
	ingredients.BLACK_TEA: {
		"color": Color.WEB_MAROON,
		"flavor": [0,0,0,0,1,0]
	},
	ingredients.ORANGE_PEEL: {
		"color": Color.DARK_ORANGE,
		"flavor": [0,0,1,0,0,0]
	},
	ingredients.HIBISCUS: {
		"color": Color.MEDIUM_VIOLET_RED,
		"flavor": [0,1,0,0,0,0]
	},
	ingredients.PINE_NEEDLE: {
		"color": Color.ORANGE,
		"flavor": [0,0,0,1,0,0]
	},
}
