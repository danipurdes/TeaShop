extends CharacterBody3D

@export var reach_magnitude = 5.0
@export var walk_speed = 3
@export var mouse_rotate_sensitivity_h = 9.5
@export var joystick_rotate_sensitivity_h = 95
@export var rotate_invert_h = -1
@onready var Camera = $Camera
@onready var Raycast = $Camera/RayCast3D

var raycastEvent
var heldItem = null
var interact_enabled = true
var movement_enabled = true
var mouselook_horizontal:float
var mouselook_enabled = true
var past_lookat_target

signal held_item_changed(held_item)
signal lookat_changed(new_target)

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
	if interact_enabled:
		var collider = Raycast.get_collider()
		
		#Object Scanning
		updateLookAtTarget(collider)
		
		#Object Picking
		if Input.is_action_just_pressed("mouse1"):
			pick_object(collider)
	
	# Horizontal Rotation
	if mouselook_enabled:
		if Input.get_axis("look_left", "look_right"):
			mouselook_horizontal = Input.get_axis("look_left", "look_right")
			mouselook_horizontal *= joystick_rotate_sensitivity_h
		set_rotation_degrees(calculateNewRotation(delta))
		mouselook_horizontal = 0
	
	# Movement
	if movement_enabled:
		# Move Held Item
		if heldItem != null:
			heldItem.position = $Hand/HeldItem.global_position
			heldItem.rotation = $Hand/HeldItem.global_rotation
		
		# Move Player
		var move_axis = Vector3(Input.get_axis("walk_left","walk_right"), 0, Input.get_axis("walk_forward","walk_backward"))
		move_axis = move_axis.normalized()
		move_axis *= walk_speed
		
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
	if item == null or heldItem != null:
		return false
	
	if "currentItem" in item and item.currentItem != null:
		return false
	
	updateHeldItem(item)
	return true

func updateHeldItem(item):
	heldItem = item
	#heldItem.state_changed.connect(updateHeldItemLabel)
	heldItem.monitoring = false
	heldItem.monitorable = false
	if "obj_attached_to" in item and item.obj_attached_to != null and item.obj_attached_to.has_method("takeItem"):
		item.obj_attached_to.takeItem()
	held_item_changed.emit(heldItem)

func requestDropHeldItem(dropRequestor):
	return dropHeldItem(dropRequestor) if heldItem != null else null

func dropHeldItem(dropRequestor):
	var oldHeldItem = heldItem
	heldItem.monitoring = true
	heldItem.monitorable = true
	heldItem.position = dropRequestor.global_position
	#heldItem.state_changed.disconnect(updateHeldItemLabel)
	heldItem = null
	held_item_changed.emit(null)
	return oldHeldItem

func destroyHeldItem():
	#heldItem.state_changed.disconnect(updateHeldItemLabel)
	heldItem.queue_free()
	heldItem = null
	held_item_changed.emit(null)

func getHeldItem():
	return heldItem

func updateLookAtTarget(new_target):
	if past_lookat_target != new_target:
		lookat_changed.emit(new_target)

func pick_object(target):
	if "item_type" in target:
		if attemptPickup(target):
			$PingBoop.play()
			return
		
		if target.has_method("useItem") and target.useItem(heldItem):
			$UseBoop.play()
			return
		
		$BadBoop.play()
	elif target.has_method("useItem") and target.useItem(heldItem):
		$UseBoop.play()
		if (heldItem != null):
			held_item_changed.emit(heldItem)
	else:
		$BadBoop.play()
