extends Camera3D

@export var vertical_rotation_max = 45
@export var vertical_rotation_min = -45
@export var rotate_sensitivity_v = .2
@export var rotate_invert_v = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var new_rotation = rotation_degrees
		new_rotation.x += rotate_invert_v * event.relative.y * rotate_sensitivity_v
		new_rotation.x = clampi(new_rotation.x, vertical_rotation_min, vertical_rotation_max)
		set_rotation_degrees(new_rotation)
