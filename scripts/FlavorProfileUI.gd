extends Label3D

func _process(_delta):
	pass

func updateLabel(_flavor_profile):
	text = _flavor_profile._to_amount_string()
	#TODO: Add caffeine icon
