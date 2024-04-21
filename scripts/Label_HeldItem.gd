extends Label

func onLabelUpdate(heldItemName):
	if heldItemName != null:
		text = heldItemName
	else:
		text = "none"
