extends StaticBody3D

@export var machine_type:String = "oxidizer"
@export var idle_color:Color = Color(0.303, 0.303, 0.303)
@export var working_color:Color = Color(0.708, 0.708, 0.708)
@export var obj_ingredient:PackedScene

@onready var ingredients:Ingredients = $Blend.ingredients
@onready var progress_bar = $SubViewport/CanvasLayer/ProgressBar

var state:String = "idle"
var oxidizing_stages:Array[Constants.ingredients] = [Constants.ingredients.GREEN_TEA, Constants.ingredients.BLACK_TEA]

func _ready():
	ingredients.ingredients_changed.connect(on_ingredients_changed)
	$Blend.set_surface_override_material(0, create_material(idle_color))

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
					start_oxidizing()
					return true
				_:
					return false
		"started":
			if held_item != null:
				return false
			if ingredients.ingredient_list.is_empty():
				return false
			if ingredients.ingredient_list.front() not in oxidizing_stages:
				return false
			stop_oxidizing()
			return true
		_:
			return false

func start_oxidizing():
	$GreenTeaTimer.start()
	state = "started"
	ingredients.clear_ingredients()
	progress_bar.add_theme_stylebox_override("fill", create_stylebox(Constants.ingredientColorMap[Constants.ingredients.GREEN_TEA]))

func stop_oxidizing():
	spawn_tea_brick()
	state = "idle"
	ingredients.clear_ingredients()
	$ParticleEmitter.emitting = true
	$GreenTeaTimer.stop()
	$BlackTeaTimer.stop()
	progress_bar.value = progress_bar.min_value

func _on_green_tea_timer_timeout():
	ingredients.set_ingredient(Constants.ingredients.GREEN_TEA)
	$BlackTeaTimer.start()
	progress_bar.add_theme_stylebox_override("fill", create_stylebox(Constants.ingredientColorMap[Constants.ingredients.BLACK_TEA]))

func _on_black_tea_timer_timeout():
	ingredients.set_ingredient(Constants.ingredients.BLACK_TEA)
	progress_bar.value = progress_bar.max_value

func spawn_tea_brick():
	if !ingredients.ingredient_list.is_empty():
		$CounterHotspot.spawnObject(obj_ingredient.instantiate(), ingredients.ingredient_list.front(), [])

func on_ingredients_changed(new_ingredients):
	match state:
		"idle":
			$Blend.set_surface_override_material(0, create_material(idle_color))
			$IngredientLabel.on_label_update("Inactive")
			return
		"started":
			if new_ingredients.size() == 0:
				$Blend.set_surface_override_material(0, create_material(working_color))
				$IngredientLabel.on_label_update("Working")
				return
			$IngredientLabel.on_label_update(new_ingredients.ingredients_to_string())
			return
		_:
			return

func create_material(new_color:Color):
	var new_material = StandardMaterial3D.new()
	new_material.albedo_color = new_color
	return new_material

func create_stylebox(new_color:Color):
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = new_color
	return new_stylebox
