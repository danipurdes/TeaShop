extends Control

signal resume_requested

@onready var ResumeButton = $MarginContainer/CenterContainer/HBoxContainer/ResumeButton
@onready var QuitButton = $MarginContainer/CenterContainer/HBoxContainer/QuitToMenuButton

func _ready():
	ResumeButton.pressed.connect(requestResume)
	QuitButton.pressed.connect(returnToTitleMenu)
	ResumeButton.tree_entered.connect(set_focus)

func requestResume():
	resume_requested.emit()
	
func returnToTitleMenu():
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func set_focus():
	ResumeButton.grab_focus()
