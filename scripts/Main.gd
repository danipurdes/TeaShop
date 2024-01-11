extends Node3D

@export var crush_leaf_count = 0

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

func crushLeavesExit():
	changeCrushLeafCount(1)

func changeCrushLeafCount(delta):
	crush_leaf_count += delta
	$HUD/Control/GridContainer/Label_CrushLeafCount.set_text(str(crush_leaf_count))

func _on_oxidizer_on_oxidize_enter():
	changeCrushLeafCount(-1)
