extends StaticBody3D

@export var machine_type:String = "oxidizer"
@export var idle_material:StandardMaterial3D
@export var started_material:StandardMaterial3D
@export var obj_ingredient:PackedScene
@export var greenStyle:StyleBoxFlat
@export var blackStyle:StyleBoxFlat

@onready var ingredients = Ingredients.new()
@onready var indicator_mat:StandardMaterial3D = StandardMaterial3D.new()
@onready var progress_bar = $SubViewport/CanvasLayer/ProgressBar

var state:String = "idle"

func _ready():
	ingredients.ingredients_changed.connect(on_ingredients_changed)
	$IndicatorMesh.set_surface_override_material(0, idle_material)

func _process(_delta):
	if !$GreenTeaTimer.is_stopped():
		progress_bar.value = progress_bar.max_value * (1 - ($GreenTeaTimer.time_left / $GreenTeaTimer.wait_time))
	elif !$BlackTeaTimer.is_stopped():
		progress_bar.value = progress_bar.max_value * (1 - ($BlackTeaTimer.time_left / $BlackTeaTimer.wait_time))

func useItem(held_item):
	match state:
		"idle":
			if $CounterHotspot.currentItem != null:
				return false
			if !held_item.has_method("onUseItem") or !held_item.onUseItem(self):
				return false
			if "item_type" not in held_item:
				return false
			match held_item.item_type:
				"leaf_tray":
					startOxidizeLeaves()
					return true
				_:
					return false
		"started":
			if held_item != null or ingredients.ingredients.size() == 0:
				return false
			match ingredients.ingredients[0]:
				Constants.ingredients.GREEN_TEA:
					stopOxidizeLeaves()
					return true
				Constants.ingredients.BLACK_TEA:
					stopOxidizeLeaves()
					return true
				_:
					return false
		_:
			return false

func startOxidizeLeaves():
	$GreenTeaTimer.start()
	state = "started"
	ingredients.clearIngredients()
	progress_bar.add_theme_stylebox_override("fill", greenStyle)

func stopOxidizeLeaves():
	spawnTeaBrick()
	state = "idle"
	ingredients.clearIngredients()
	$ParticleEmitter.emitting = true
	$GreenTeaTimer.stop()
	$BlackTeaTimer.stop()
	progress_bar.value = progress_bar.min_value

func _on_green_tea_timer_timeout():
	ingredients.clearIngredients()
	ingredients.addIngredient(Constants.ingredients.GREEN_TEA)
	$BlackTeaTimer.start()
	progress_bar.add_theme_stylebox_override("fill", blackStyle)

func _on_black_tea_timer_timeout():
	ingredients.clearIngredients()
	ingredients.addIngredient(Constants.ingredients.BLACK_TEA)
	progress_bar.value = progress_bar.max_value

func spawnTeaBrick():
	if ingredients.ingredients.size() > 0:
		$CounterHotspot.spawnObject(obj_ingredient.instantiate(), ingredients.ingredients[0], [])

func update_ingredients_label(new_ingredients):
	var output = ""
	var nameKeys = Constants.ingredients.keys()
	for ingredient in new_ingredients:
		output += nameKeys[ingredient]
	$IngredientLabel.onLabelUpdate(output)

func on_ingredients_changed(_new_ingredients):
	match state:
		"idle":
			$IndicatorMesh.set_surface_override_material(0, idle_material)
			$IngredientLabel.onLabelUpdate("Inactive")
			return
		"started":
			if _new_ingredients.size() == 0:
				$IndicatorMesh.set_surface_override_material(0, started_material)
				$IngredientLabel.onLabelUpdate("Working")
				return
			$IndicatorMesh.set_surface_override_material(0, ingredients.ingredientsMat)
			$IngredientLabel.onLabelUpdate(ingredients.ingredientsToString())
			return
		_:
			return
