extends Label

func onLabelUpdate(heldItemName):
	#print_debug(heldItemName)
	if heldItemName != null:
		text = heldItemName
