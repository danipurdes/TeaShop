extends CharacterBody3D

signal held_item_changed(itemName)
signal changeUseLabel(label)

var raycastEvent
@export var reach_magnitude = 5.0
@export var walk_speed = 3
@export var mouse_rotate_sensitivity_h = 9.5
@export var joystick_rotate_sensitivity_h = 95
@export var rotate_invert_h = -1
var heldItem = null

var interact_enabled = true
var movement_enabled = true

var mouselook_horizontal:float
var mouselook_enabled = true
@onready var Camera = $Camera
@onready var Raycast = $Camera/RayCast3D

func _ready():
	get_parent().pause_state_entered.connect(on_pause_state_entered)
	get_parent().pause_state_exited.connect(on_pause_state_exited)

func on_pause_state_entered():
	mouselook_enabled = false
	Camera.mouselook_enabled = false
	
	interact_enabled = false
	movement_enabled = false

func on_pause_state_exited():
	mouselook_enabled = true
	Camera.mouselook_enabled = true
	
	interact_enabled = true
	movement_enabled = true

func _physics_process(delta):
	if interact_enabled and Raycast.is_colliding():
		var collider = Raycast.get_collider()
		
		#Object Scanning
		setUseLabel(collider)
		
		#Object Picking
		if Input.is_action_just_pressed("mouse1"):
			if "item_type" in collider:
				if attemptPickup(collider):
					$PingBoop.play()
				elif collider.has_method("useItem") and collider.useItem(heldItem):
					$UseBoop.play()
				else:
					$BadBoop.play()
			elif collider.has_method("useItem") and collider.useItem(heldItem):
				$UseBoop.play()
				if (heldItem != null):
					held_item_changed.emit(heldItem.getName())
			else:
				$BadBoop.play()
	
	# Horizontal Rotation
	if mouselook_enabled:
		if Input.get_axis("look_left", "look_right"):
			mouselook_horizontal = Input.get_axis("look_left", "look_right")
			mouselook_horizontal *= joystick_rotate_sensitivity_h
		set_rotation_degrees(calculateNewRotation(delta))
		mouselook_horizontal = 0
	
	if movement_enabled:
		# Move Held Item
		if heldItem != null:
			heldItem.position = $Hand/HeldItem.global_position
			heldItem.rotation = $Hand/HeldItem.global_rotation
		
		# Movement
		var move_axis = Vector3()
		if Input.get_axis("walk_forward","walk_backward") != 0:
			move_axis.z += Input.get_axis("walk_forward","walk_backward")
		if Input.get_axis("walk_left","walk_right") != 0:
			move_axis.x += Input.get_axis("walk_left","walk_right")
		
		move_axis = move_axis.normalized() * walk_speed
		var move_dir = move_axis.rotated(Vector3.UP, rotation.y)
		velocity = move_dir
		
		move_and_slide()

func calculateNewRotation(delta):
	var rotation_delta = mouselook_horizontal
	rotation_delta *= delta
	rotation_delta *= rotate_invert_h
	return rotation_degrees + Vector3(0, rotation_delta, 0)

func _input(event):
	if event is InputEventMouseMotion:
		mouselook_horizontal = event.relative.x
		mouselook_horizontal *= mouse_rotate_sensitivity_h

func attemptPickup(item):
	if heldItem != null:
		return false
	
	if "currentItem" not in item:
		updateHeldItem(item)
		return true
	
	if item.currentItem == null:
		updateHeldItem(item)
		return true
	
	return false

func updateHeldItem(item):
	heldItem = item
	heldItem.state_changed.connect(updateHeldItemLabel)
	heldItem.monitoring = false
	heldItem.monitorable = false
	if "obj_attached_to" in item and item.obj_attached_to != null and item.obj_attached_to.has_method("takeItem"):
		item.obj_attached_to.takeItem()
	if heldItem.has_method("getName"):
		held_item_changed.emit(heldItem.getName())

func requestDropHeldItem(dropRequestor):
	return dropHeldItem(dropRequestor) if heldItem != null else null

func dropHeldItem(dropRequestor):
	var oldHeldItem = heldItem
	heldItem.monitoring = true
	heldItem.monitorable = true
	heldItem.position = dropRequestor.global_position
	heldItem.state_changed.disconnect(updateHeldItemLabel)
	heldItem = null
	updateHeldItemLabel("none")
	return oldHeldItem

func destroyHeldItem():
	heldItem.state_changed.disconnect(updateHeldItemLabel)
	heldItem.queue_free()
	heldItem = null
	updateHeldItemLabel("none")

func getHeldItem():
	return heldItem

func updateHeldItemLabel(held_item_name):
	held_item_changed.emit(held_item_name)

func setUseLabel(collider):
	if collider == null:
		return
	
	var resultCollider = collider
	if heldItem == null:
		if "item_type" in resultCollider:
			changeUseLabel.emit("pick up " + resultCollider.item_type)
		return
	
	if "machine_type" in resultCollider:
		if resultCollider.machine_type == "hotspot" or resultCollider.machine_type == "hotplate":
			changeUseLabel.emit("set down " + heldItem.item_type)
		return
	
	if heldItem.has_method("onUseItem") and resultCollider.has_method("useItem"):
		var heldItemKey = heldItem.getName() if heldItem.has_method("getName") else ""
		var colliderKey = resultCollider.getName() if resultCollider.has_method("getName") else ""
		var useKey = heldItemKey + "|" + colliderKey
		changeUseLabel.emit(UseLabelUtility.itemUseLabelMap.get(useKey))
		return
	
	changeUseLabel.emit("-")
