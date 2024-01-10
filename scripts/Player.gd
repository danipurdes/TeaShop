extends CharacterBody3D

signal changeHeldItem(itemName)
signal changePingLabel(label)
signal changeUseLabel(label)

var raycastEvent
@export var RAY_LENGTH = 10.0
@export var walk_speed = 2.5
@export var rotate_sensitivity_h = 1
@export var rotate_invert_h = -1
var heldItem = null

var itemUseLabelMap = {
	"teakettle_empty|sink":"fill with cold water",
	"teakettle_cold_water|hotplate":"heat kettle on stove",
	"teakettle_hot_water|teapot_empty_0":"fill teapot from kettle",
	"teapot_hot_water_1|teacup_empty":"fill teacup with tea",
	"teapot_hot_water_2|teacup_empty":"fill teacup with tea",
	"tea_brick_1|teapot_hot_water_0":"add tea to teapot",
	"tea_brick_2|teapot_hot_water_0":"add tea to teapot",
	"teacup_1|sink": "empty cup into sink",
	"teacup_2|sink": "empty cup into sink"
}

var pingLabelMap = {
	"jukebox": "toggle jukebox",
	"tea_tree": "prune tea tree",
	"leaf_crusher": "crush tea leaves",
	"oxidizer": "oxidize tea leaves"
}

func _physics_process(_delta):
	var raycastResult = getRaycastResult()
	if !raycastResult.is_empty():
		#Object Scanning
		setPingLabel(raycastResult)
		setUseLabel(raycastResult)
		
		#Object Picking
		if Input.is_action_just_pressed("mouse1"):
			if "item_type" in raycastResult.collider:
				if attemptPickup(raycastResult.collider):
					$PingBoop.play()
				else:
					$BadBoop.play()
			elif raycastResult.collider.has_method("ping"):
				if raycastResult.collider.ping():
					$PingBoop.play()
				else:
					$BadBoop.play()
		elif Input.is_action_just_pressed("mouse2"):
			if heldItem != null and raycastResult.collider.has_method("useItem"):
				if raycastResult.collider.useItem(heldItem):
					$UseBoop.play()
				else:
					$BadBoop.play()
				if (heldItem != null):
					changeHeldItem.emit(heldItem.getName())
			else:
				$BadBoop.play()
	
	# Move Held Item
	if heldItem != null:
		heldItem.position = $Hand/HeldItem.global_position
		heldItem.rotation = $Hand/HeldItem.global_rotation
	
	# Movement
	var move_axis = Vector3()
	if Input.is_action_pressed("walk_forward"):
		move_axis.z = move_axis.z - 1
	if Input.is_action_pressed("walk_backward"):
		move_axis.z = move_axis.z + 1
	if Input.is_action_pressed("walk_right"):
		move_axis.x = move_axis.x + 1
	if Input.is_action_pressed("walk_left"):
		move_axis.x = move_axis.x - 1
	
	move_axis = move_axis.normalized() * walk_speed
	var move_dir = move_axis.rotated(Vector3.UP, rotation.y)
	velocity = move_dir
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		var new_rotation = rotation_degrees
		new_rotation.y += rotate_invert_h * event.relative.x * rotate_sensitivity_h
		set_rotation_degrees(new_rotation)

func attemptPickup(item):
	if heldItem == null:
		updateHeldItem(item)
		return true
	return false

func updateHeldItem(item):
	heldItem = item
	heldItem.monitoring = false
	heldItem.monitorable = false
	changeHeldItem.emit(heldItem.getName())

func requestDropHeldItem(dropRequestor):
	if heldItem != null:
		var oldHeldItem = heldItem
		dropHeldItem(dropRequestor)
		return oldHeldItem
	return null
	
func dropHeldItem(dropRequestor):
	heldItem.monitoring = true
	heldItem.monitorable = true
	heldItem.position = dropRequestor.global_position
	heldItem = null
	changeHeldItem.emit("-")

func destroyHeldItem():
	heldItem.queue_free()
	heldItem = null
	changeHeldItem.emit("-")

func getHeldItem():
	return heldItem

func getRaycastResult():
	var camera3d = $Camera
	var from = camera3d.project_ray_origin(camera3d.get_viewport().size / 2)
	var to = from + camera3d.project_ray_normal(camera3d.get_viewport().size / 2) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
	query.collide_with_areas = true
	return get_world_3d().direct_space_state.intersect_ray(query)

func setPingLabel(raycastResult):
	var resultCollider = raycastResult.collider
	if heldItem == null and "item_type" in resultCollider:
		changePingLabel.emit("pick up " + resultCollider.item_type)
		return
	elif heldItem != null and "machine_type" in resultCollider:
		if resultCollider.machine_type == "hotspot" or resultCollider.machine_type == "hotplate":
			changePingLabel.emit("set down " + heldItem.item_type)
			return
	elif "machine_type" in resultCollider:
		changePingLabel.emit(pingLabelMap.get(resultCollider.machine_type))
		return
	changePingLabel.emit("-")
	pass

func setUseLabel(raycastResult):
	var resultCollider = raycastResult.collider
	if heldItem != null:
		if heldItem.has_method("onUseItem") and resultCollider.has_method("useItem"):
			var heldItemKey = ""
			if heldItem.has_method("getName"):
				heldItemKey = heldItem.getName()
			var colliderKey = ""
			if resultCollider.has_method("getName"):
				colliderKey = resultCollider.getName()
			var useKey = heldItemKey + "|" + colliderKey
			changeUseLabel.emit(itemUseLabelMap.get(useKey))
			return
	changeUseLabel.emit("-")
