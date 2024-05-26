extends CanvasLayer

@onready var playScreen = $GameUI
@onready var pauseScreen = $PauseScreen

func _ready():
	get_parent().pause_state_entered.connect(on_pause_state_entered)
	get_parent().pause_state_exited.connect(on_pause_state_exited)
	pauseScreen.resume_requested.connect(get_parent().on_unpause)
	
	if pauseScreen.get_parent() != null:
		remove_child(pauseScreen)

func on_pause_state_entered():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if playScreen.get_parent() != null:
		remove_child(playScreen)
	if pauseScreen.get_parent() == null:
		add_child(pauseScreen)

func on_pause_state_exited():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if pauseScreen.get_parent() != null:
		remove_child(pauseScreen)
	if playScreen.get_parent() == null:
		add_child(playScreen)
