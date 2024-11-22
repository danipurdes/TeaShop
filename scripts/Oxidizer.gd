extends StaticBody3D

@export var machine_type:String = "oxidizer"
@export var idle_color:Color = Color(0.303, 0.303, 0.303)
@export var working_color:Color = Color(0.708, 0.708, 0.708)
@export var obj_ingredient:PackedScene

@onready var ingredients:Ingredients = $Blend.ingredients
@onready var progress_bar = $SubViewport/CanvasLayer/ProgressBar

var state:String = "idle"
var oxidizing_stages:Array[Constants.ingredients] = [Constants.ingredients.GREEN_TEA, Constants.ingredients.BLACK_TEA]
var oxidizing_index:int = 0
var tween:Tween

signal state_changed(new_state:String)

func _ready():
	ingredients.ingredients_changed.connect(on_ingredients_changed)
	state_changed.connect($IngredientLabel.on_label_update)
	$Blend.set_surface_override_material(0, create_material(idle_color))

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
	$OxidizingTimer.start()
	set_state("started")
	ingredients.clear_ingredients()
	oxidizing_index = 0
	progress_bar.add_theme_stylebox_override("fill", create_stylebox(Constants.ingredientColorMap[oxidizing_stages.front()]))
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(progress_bar, "value", progress_bar.max_value, $OxidizingTimer.wait_time)

func stop_oxidizing():
	spawn_tea_brick()
	set_state("idle")
	ingredients.clear_ingredients()
	$ParticleEmitter.emitting = true
	$OxidizingTimer.stop()
	progress_bar.value = progress_bar.min_value

func on_oxidizing_timer_timeout():
	ingredients.set_ingredient(oxidizing_stages[oxidizing_index])
	if tween:
		tween.kill()
	
	if oxidizing_index < oxidizing_stages.size():
		oxidizing_index += 1
		$OxidizingTimer.start()
		progress_bar.value = progress_bar.min_value
		tween = create_tween()
		tween.tween_property(progress_bar, "value", progress_bar.max_value, $OxidizingTimer.wait_time)

func spawn_tea_brick():
	if !ingredients.ingredient_list.is_empty():
		$CounterHotspot.spawnObject(obj_ingredient.instantiate(), ingredients.ingredient_list.front(), [])

func on_ingredients_changed(new_ingredients):
	match state:
		"idle":
			$Blend.set_surface_override_material(0, create_material(idle_color))
			return
		"started":
			if new_ingredients.is_empty():
				$Blend.set_surface_override_material(0, create_material(working_color))
				return
			return
		_:
			return

func set_state(new_state):
	if new_state == state:
		return
	state_changed.emit(new_state)

func create_material(new_color:Color):
	var new_material = StandardMaterial3D.new()
	new_material.albedo_color = new_color
	return new_material

func create_stylebox(new_color:Color):
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = new_color
	return new_stylebox
