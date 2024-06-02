extends Area3D

signal state_changed(state_text)

@export var item_type = "basket"
@export var leaf_count = 0
@export var leaf_count_max = 5
var obj_attached_to = null

func _ready():
	updateLabel(getName())
	state_changed.connect(updateLabel)
	
func onUseItem(itemToUseOn):
	if "machine_type" in itemToUseOn and itemToUseOn.machine_type == "tea_tree":
		return tryUpdateLeafCount(1)
	elif "machine_type" in itemToUseOn and itemToUseOn.machine_type == "leaf_crusher":
		return tryUpdateLeafCount(-1)
	return false

func tryUpdateLeafCount(deltaLeaf):
	var newLeafCount = leaf_count + deltaLeaf
	if newLeafCount <= leaf_count_max and newLeafCount >= 0:
		leaf_count = newLeafCount
		state_changed.emit(getName())
		return true
	return false

func getName():
	return str(leaf_count)

func updateLabel(new_label_text):
	$Label.text = new_label_text
