extends Node3D

@export var tea_leaf_count = 0
@export var crush_leaf_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func pluckLeaves():
	changeTeaLeafCount(1)

func crushLeavesEnter():
	changeTeaLeafCount(-1)

func crushLeavesExit():
	print_debug("whut")
	changeCrushLeafCount(1)
	
func changeTeaLeafCount(delta):
	tea_leaf_count = tea_leaf_count + delta
	$HUD/Label_FreshLeafCount.set_text(str(tea_leaf_count))

func changeCrushLeafCount(delta):
	crush_leaf_count = crush_leaf_count + delta
	$HUD/Label_CrushLeafCount.set_text(str(crush_leaf_count))

func getTeaLeafCount():
	return tea_leaf_count
