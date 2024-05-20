extends Camera3D

@export var vertical_rotation_max = 60
@export var vertical_rotation_min = -60
@export var rotate_sensitivity_v = 5
@export var rotate_invert_v = -1

var mouselook_vertical:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	set_rotation_degrees(calculateNewRotation(delta))
	mouselook_vertical = 0

func calculateNewRotation(delta):
	var rotation_delta = mouselook_vertical
	rotation_delta *= rotate_sensitivity_v
	rotation_delta *= delta
	rotation_delta *= rotate_invert_v
	
	var new_rotation_x = rotation_degrees.x + rotation_delta
	if new_rotation_x > vertical_rotation_max:
		new_rotation_x = vertical_rotation_max
	elif new_rotation_x < vertical_rotation_min:
		new_rotation_x = vertical_rotation_min
	return Vector3(new_rotation_x, rotation_degrees.y, rotation_degrees.z)

func _input(event):
	if event is InputEventMouseMotion:
		mouselook_vertical = event.relative.y
