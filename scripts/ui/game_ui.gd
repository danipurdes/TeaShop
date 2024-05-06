extends MarginContainer

var is_paused:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	is_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if !is_paused:
			add_child(load("res://scenes/ui/pause_screen.tscn").instantiate())
		is_paused != is_paused
