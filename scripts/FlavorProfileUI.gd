extends Node3D

func _process(_delta):
	pass
#	var camera3d = get_node("/root/Node3D/Player")
#	look_at(camera3d.position, Vector3.UP, true)
#	var new_rotation = Vector3(0, rotation_degrees.y, 0)
#	set_rotation_degrees(new_rotation)

func updateLabel(_flavor_profile):
	$Grassy_Amount.text = str(_flavor_profile.grassy)
	$Floral_Amount.text = str(_flavor_profile.floral)
	$Fruity_Amount.text = str(_flavor_profile.fruity)
	$Earthy_Amount.text = str(_flavor_profile.earthy)
	$Smoky_Amount.text = str(_flavor_profile.smoky)
	$Caffeine_Amount.text = str(_flavor_profile.caffeine)
