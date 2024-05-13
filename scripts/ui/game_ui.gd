extends MarginContainer

var is_paused:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Node3D/Player").changeHeldItem.connect($HeldItemContainer/Label_HeldItem.onLabelUpdate)
	get_node("/root/Node3D/Player").changeUseLabel.connect($MousePeek/UseLabel.onLabelUpdate)
	is_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if !is_paused:
			var pause_menu = load("res://scenes/ui/pause_screen.tscn").instantiate()
			#pause_menu.instantiate()
			pause_menu.tree_exiting.connect(unpause)
			add_child(pause_menu)
			is_paused = true

func unpause():
	is_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
