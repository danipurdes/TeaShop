extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CenterContainer/HBoxContainer/ResumeButton.grab_focus()

func _process(_delta):
	if Input.is_action_just_pressed("escape") or Input.is_action_just_pressed("ui_cancel"):
		queue_free()

func _on_resume_button_pressed():
	queue_free()

func _on_quit_to_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
