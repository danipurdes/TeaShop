extends Label3D

func _process(_delta):
	pass

func updateLabel(flavor_profile):
	text = flavor_profile._to_amount_string()
	#TODO: Add caffeine icon
