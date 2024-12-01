class_name Constants

enum ingredients {
	NONE,
	WHITE_TEA,
	GREEN_TEA,
	BLACK_TEA,
	ORANGE_PEEL,
	HIBISCUS,
	PINE_NEEDLE,
	LAVENDER,
	JASMINE,
	WHEATGRASS,
	BLACK_CARDAMOM,	
	COFFEE_BEAN,
	DARK_CHOCOLATE
}

enum flavors {
	NONE,
	GRASSY,
	FLORAL,
	FRUITY,
	EARTHY,
	SMOKY,
	CAFFEINE
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
	ingredients.WHITE_TEA: [0,0,1,0,0,1],
	ingredients.GREEN_TEA: [1,0,0,0,0,1],
	ingredients.BLACK_TEA: [0,0,0,0,1,1],
	ingredients.ORANGE_PEEL: [0,0,1,0,0,0],
	ingredients.HIBISCUS: [0,0,1,0,0,0],
	ingredients.PINE_NEEDLE: [0,0,0,1,0,0],
	ingredients.LAVENDER: [0,1,0,0,0,0],
	ingredients.JASMINE: [0,1,0,0,0,0],
	ingredients.WHEATGRASS: [1,0,0,0,0,0],
	ingredients.BLACK_CARDAMOM: [0,0,0,0,1,0],
	ingredients.COFFEE_BEAN: [0,0,0,1,0,1],
	ingredients.DARK_CHOCOLATE: [0,0,1,0,0,1]
}

static var ingredientColorMap = {
	ingredients.NONE: Color(0.1,0.1,0.1,0.1),
	ingredients.WHITE_TEA: Color.SILVER,
	ingredients.GREEN_TEA: Color.DARK_GREEN,
	ingredients.BLACK_TEA: Color.WEB_MAROON,
	ingredients.ORANGE_PEEL: Color.DARK_ORANGE,
	ingredients.HIBISCUS: Color.MEDIUM_VIOLET_RED,
	ingredients.PINE_NEEDLE: Color.ORANGE,
	ingredients.LAVENDER: Color.LAVENDER,
	ingredients.JASMINE: Color.PALE_GOLDENROD,
	ingredients.WHEATGRASS: Color.LAWN_GREEN,
	ingredients.BLACK_CARDAMOM: Color.DARK_SLATE_GRAY,
	ingredients.COFFEE_BEAN: Color.SADDLE_BROWN,
	ingredients.DARK_CHOCOLATE: Color.CHOCOLATE
}

static var ingredientMap = {
	ingredients.NONE: {
		"color": Color.TRANSPARENT,
		"flavor": [0,0,0,0,0,0]
	},
	ingredients.WHITE_TEA: {
		"color": Color.SILVER,
		"flavor": [0,0,1,0,0,0]
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
