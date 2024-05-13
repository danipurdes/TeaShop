extends Label

func _ready():
	pass

func onLabelUpdate(heldItemName):
	if heldItemName != null:
		text = heldItemName
	else:
		text = "none"
