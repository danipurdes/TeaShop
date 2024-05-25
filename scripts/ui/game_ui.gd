extends MarginContainer

func _ready():
	get_node("/root/Node3D/Player").changeHeldItem.connect($HeldItemContainer/Label_HeldItem.onLabelUpdate)
	get_node("/root/Node3D/Player").changeUseLabel.connect($MousePeek/UseLabel.onLabelUpdate)
	get_node("/root/Node3D/VillagerSpawner").current_order_changed.connect($OrderContainer/OrderLabel.onLabelUpdate)
