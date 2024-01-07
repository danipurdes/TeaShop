extends Node3D

@export var tea_leaf_count = 0
@export var crush_leaf_count = 0
@export var green_tea_count = 0
@export var black_tea_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("mouse1"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func pluckLeaves():
	changeTeaLeafCount(1)

func crushLeavesEnter():
	changeTeaLeafCount(-1)

func crushLeavesExit():
	changeCrushLeafCount(1)
	
func changeTeaLeafCount(delta):
	tea_leaf_count = tea_leaf_count + delta
	$HUD/Control/GridContainer/Label_FreshLeafCount.set_text(str(tea_leaf_count))

func changeCrushLeafCount(delta):
	crush_leaf_count = crush_leaf_count + delta
	$HUD/Control/GridContainer/Label_CrushLeafCount.set_text(str(crush_leaf_count))

func _on_oxidizer_harvested_black():
	black_tea_count = black_tea_count + 1

func _on_oxidizer_harvested_green():
	green_tea_count = green_tea_count + 1

func _on_oxidizer_on_oxidize_enter():
	changeCrushLeafCount(-1)
