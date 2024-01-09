extends Camera3D

var rotate_sensitivity_v = .1
var rotate_invert_v = -1

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
		new_rotation.x = 30 if new_rotation.x > 30 else new_rotation.x
		new_rotation.x = -30 if new_rotation.x < -30 else new_rotation.x
		set_rotation_degrees(new_rotation)
