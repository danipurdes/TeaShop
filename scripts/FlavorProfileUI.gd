extends Label3D

func _process(_delta):
	pass
#	var camera3d = get_node("/root/Node3D/Player")
#	look_at(camera3d.position, Vector3.UP, true)
#	var new_rotation = Vector3(0, rotation_degrees.y, 0)
#	set_rotation_degrees(new_rotation)

func updateLabel(_flavor_profile):
	var newText = ""
	for n in _flavor_profile.grassy:
		newText += "0"
	for n in _flavor_profile.floral:
		newText += "1"
	for n in _flavor_profile.fruity:
		newText += "2"
	for n in _flavor_profile.earthy:
		newText += "3"
	for n in _flavor_profile.smoky:
		newText += "4"
	text = newText
	#TODO: Add caffeine icon
