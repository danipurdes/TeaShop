extends MarginContainer

@onready var world = get_node("/root/Node3D")
@onready var player = get_node("/root/Node3D/Player")
@onready var villager_spawner = get_node("/root/Node3D/VillagerSpawner")
@onready var mouse_peek_panel = $MousePeekPanel
@onready var order_label = $OrderPanel/MarginContainer/OrderLabels/OrderLabel
@onready var score_label = $ScorePanel/MarginContainer/HBoxContainer/ScoreValue
@onready var cursor = $Cursor

func _ready():
	# Current Order
	villager_spawner.current_order_changed.connect(order_label.on_label_update)
	
	# Score
	world.score_changed.connect(score_label.on_label_update)

	# Held Item
	player.held_item_changed.connect($HeldItemPanel.on_target_changed)
	
	# Inspection Panel
	player.lookat_changed.connect($InspectionPanel.on_target_changed)

	# Mouse Peek Panel
	player.held_item_changed.connect(mouse_peek_panel.on_held_item_changed)
	player.lookat_changed.connect(mouse_peek_panel.on_target_item_changed)

	# Cursor
	mouse_peek_panel.action_changed.connect(cursor.change_cursor)
