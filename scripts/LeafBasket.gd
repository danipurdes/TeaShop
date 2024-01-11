extends Area3D

@export var item_type = "basket"
@export var leaf_count = 0
@export var leaf_count_max = 5

func _ready():
	updateLabel()
	
func onUseItem(itemToUseOn):
	if "machine_type" in itemToUseOn and itemToUseOn.machine_type == "tea_tree":
		return tryUpdateLeafCount(1)
	elif "machine_type" in itemToUseOn and itemToUseOn.machine_type == "leaf_crusher":
		return tryUpdateLeafCount(-1)
	return false

func tryUpdateLeafCount(deltaLeaf):
	var newLeafCount = leaf_count + deltaLeaf
	print_debug("old: " + str(leaf_count) + ", new: " + str(newLeafCount))
	if newLeafCount <= leaf_count_max and newLeafCount >= 0:
		leaf_count = newLeafCount
		updateLabel()
		return true
	return false

func getName():
	return item_type + "_" + str(leaf_count)

func updateLabel():
	$Label.text = getName()
