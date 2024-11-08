extends MarginContainer

func _ready():
	get_node("/root/Node3D/Player").held_item_changed.connect($HeldItems/HeldItemContainer/Label_HeldItem.onLabelUpdate)
	get_node("/root/Node3D/Player").changeUseLabel.connect($MousePeeks/MousePeek/UseLabel.onLabelUpdate)
	get_node("/root/Node3D/VillagerSpawner").current_order_changed.connect($OrderContainer/OrderLabels/OrderLabel.onLabelUpdate)
	get_node("/root/Node3D").score_changed.connect($Scorecard/ScorecardLabels/ScoreValue.onLabelUpdate)
