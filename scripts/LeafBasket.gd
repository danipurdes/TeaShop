extends Area3D

signal state_changed(state_text)

@export var item_type = "basket"
@export_range(0,100) var leaf_count_max = 20

var leaf_count_current = 0
var obj_attached_to = null

func _ready():
	state_changed.connect($Label.on_label_update)
	state_changed.emit(getName())
	
func onUseItem(_itemToUseOn):
	return false

func deposit_leaves(requested_amount):
	if requested_amount <= 0:
		return 0
	
	var leaves_deposited = min(leaf_count_max - leaf_count_current, requested_amount)
	leaf_count_current += leaves_deposited
	state_changed.emit(getName())
	return leaves_deposited

func withdraw_leaves(requested_amount):
	if requested_amount <= 0:
		return 0
	
	var leaves_withdrawn = min(requested_amount, leaf_count_current)
	leaf_count_current -= leaves_withdrawn
	state_changed.emit(getName())
	return leaves_withdrawn

func getName():
	return str(leaf_count_current) + "/" + str(leaf_count_max)
