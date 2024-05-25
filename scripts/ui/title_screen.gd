extends Control

@onready var StartButton = $MarginContainer/CenterContainer/CenterContainer2/StartButton
@onready var QuitButton = $MarginContainer/CenterContainer/CenterContainer2/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	StartButton.pressed.connect(on_game_started)
	QuitButton.pressed.connect(on_game_quit)
	StartButton.grab_focus()

func on_game_started():
	get_tree().change_scene_to_file("res://scenes/teashop.tscn")

func on_game_quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
