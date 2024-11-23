extends StaticBody3D

@export var machine_type:String = "leaf_crusher"
@export var allow_list:Array[String] = ["leaf_tray"]
@export var spawnObj:PackedScene
@export var spawnTea:Constants.ingredients = Constants.ingredients.NONE
@export var leaf_tray:PackedScene
@export_range(0,100) var leaf_count_max = 20

var state = "idle"
var leaf_count_current = 0

signal state_changed(new_state_text)

func _ready():
	$CounterHotspot.object_taken.connect(request_start_crushing)
	state_changed.connect($CapacityLabel.on_label_update)
	$CrushTimer.timeout.connect(stop_crushing)

	$StatusLight.light_color = Color.GREEN

	if spawnObj != null:
		$CounterHotspot.spawnObject(
			spawnObj.instantiate(),
			spawnTea,
			allow_list
		)


func useItem(heldItem):
	if heldItem == null:
		return false
	if !heldItem.has_method("onUseItem"):
		return false
	if $CounterHotspot.currentItem != null:
		return false
	if "item_type" not in heldItem:
		return heldItem.onUseItem(self)
	
	match heldItem.item_type:
		"basket":
			var leaves_withdrawn = heldItem.withdraw_leaves(leaf_count_max - leaf_count_current)
			if leaves_withdrawn <= 0:
				return false
			deposit_leaves(leaves_withdrawn)
			request_start_crushing()
			return true
		_:
			return false

func deposit_leaves(requested_amount):
	if requested_amount <= 0:
		return 0
	
	var leaves_deposited = min(leaf_count_max - leaf_count_current, requested_amount)
	leaf_count_current += leaves_deposited
	state_changed.emit(getName())
	return leaves_deposited

func request_start_crushing():
	if leaf_count_current > 0 and $CounterHotspot.currentItem == null:
		start_crushing()

func start_crushing():
	state = "active"
	$StatusLight.light_color = Color.RED
	$Hitbox.set_disabled(true)
	$CrushTimer.start()

func stop_crushing():
	state = "idle"
	$StatusLight.light_color = Color.GREEN
	$Hitbox.set_disabled(false)
	$CounterHotspot.spawnObject(
		leaf_tray.instantiate(),
		Constants.ingredients.WHITE_TEA,
		allow_list
	)
	leaf_count_current = max(0, leaf_count_current - 1)
	state_changed.emit(getName())

func getName():
	return str(leaf_count_current) + "/" + str(leaf_count_max)
