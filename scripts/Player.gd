extends CharacterBody3D

@export var reach_magnitude = 5.0
@export var walk_speed = 3
@export var mouse_rotate_sensitivity_h = 9.5
@export var joystick_rotate_sensitivity_h = 95
@export var rotate_invert_h = -1

@onready var camera = $Camera
@onready var raycast = $Camera/RayCast3D

var raycast_event
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
	camera.mouselook_enabled = false
	
	interact_enabled = false
	movement_enabled = false

func on_pause_state_exited():
	mouselook_enabled = true
	camera.mouselook_enabled = true
	
	interact_enabled = true
	movement_enabled = true

func _physics_process(delta):
	if interact_enabled:
		var collider = raycast.get_collider()
		
		#Object Scanning
		update_lookat_target(collider)
		
		#Object Picking
		if Input.is_action_just_pressed("mouse1"):
			pick_object(collider)
	
	# Horizontal Rotation
	if mouselook_enabled:
		if Input.get_axis("look_left", "look_right"):
			mouselook_horizontal = Input.get_axis("look_left", "look_right")
			mouselook_horizontal *= joystick_rotate_sensitivity_h
		set_rotation_degrees(calculate_new_rotation(delta))
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

func calculate_new_rotation(delta):
	var rotation_delta = mouselook_horizontal
	rotation_delta *= delta
	rotation_delta *= rotate_invert_h
	return rotation_degrees + Vector3(0, rotation_delta, 0)

func _input(event):
	if event is InputEventMouseMotion:
		mouselook_horizontal = event.relative.x
		mouselook_horizontal *= mouse_rotate_sensitivity_h

func attempt_pickup(item):
	if item == null or heldItem != null:
		return false
	if "current_item" in item and item.current_item != null:
		return false
	update_held_item(item)
	return true

func update_held_item(item):
	heldItem = item
	heldItem.monitoring = false
	heldItem.monitorable = false
	if "obj_attached_to" in item and item.obj_attached_to != null and item.obj_attached_to.has_method("take_item"):
		item.obj_attached_to.take_item()
	held_item_changed.emit(heldItem)

func request_drop_held_item(drop_requestor):
	return drop_held_item(drop_requestor) if heldItem != null else null

func drop_held_item(drop_requestor):
	var old_held_item = heldItem
	heldItem.monitoring = true
	heldItem.monitorable = true
	heldItem.position = drop_requestor.global_position
	heldItem = null
	held_item_changed.emit(null)
	return old_held_item

func destroy_held_item():
	heldItem.queue_free()
	heldItem = null
	held_item_changed.emit(null)

func update_lookat_target(new_target):
	if past_lookat_target != new_target:
		lookat_changed.emit(new_target)

func pick_object(target):
	if target == null:
		return

	if "item_type" in target:
		if attempt_pickup(target):
			$PingBoop.play()
			return
		if target.has_method("useItem") and target.useItem(heldItem):
			$UseBoop.play()
			return
		$BadBoop.play()
		return
	
	if target.has_method("useItem") and target.useItem(heldItem):
		$UseBoop.play()
		if (heldItem != null):
			held_item_changed.emit(heldItem)
		return

	$BadBoop.play()
