extends Node3D

signal pause_state_entered
signal pause_state_exited

var is_paused = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause_state()
	
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func toggle_pause_state():
	if !is_paused:
		on_pause()
	else:
		on_unpause()

func on_pause():
	is_paused = true
	pause_state_entered.emit()

func on_unpause():
	is_paused = false
	pause_state_exited.emit()
