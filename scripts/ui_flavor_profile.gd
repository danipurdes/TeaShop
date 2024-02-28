extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var camera3d = get_node("/root/Node3D/Player")
	#var new_rotation = camera3d.rotation_degrees + Vector3(0, 0, 0)
	#set_rotation_degrees(new_rotation)
	look_at(camera3d.position, Vector3.UP, true)
	var new_rotation = Vector3(0, rotation_degrees.y, 0)
	set_rotation_degrees(new_rotation)
