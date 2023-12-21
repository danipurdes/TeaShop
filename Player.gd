extends CharacterBody3D

var doMouse1RequestRaycast = false
var doMouse2RequestRaycast = false
var raycastEvent
var RAY_LENGTH = 1000.0
var walk_speed = 2.0
var rotate_sensitivity_h = 1
var rotate_invert_h = -1
var heldItem = null
var heldHitbox = null

func _physics_process(_delta):
	# Object Picking
	if Input.is_action_just_pressed("mouse1"):
		var result = getRaycastResult()
		if (!result.is_empty() and result.collider.has_method("ping")):
			result.collider.ping()
		doMouse1RequestRaycast = false
	elif Input.is_action_just_pressed("mouse2"):
		var result = getRaycastResult()
		if (!result.is_empty() and result.collider.has_method("ping2")):
			result.collider.ping2()
		doMouse2RequestRaycast = false
	
	# Move Held Item
	if heldItem != null:
		heldItem.position = $Hand/HeldItem.global_position
	
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
	#elif event is InputEventMouseButton and event.pressed and event.button_index == 1:
	#	doMouse1RequestRaycast = true
	#	raycastEvent = event
	#	print(event)
	#elif event is InputEventMouseButton and event.pressed and event.button_index == 2:
	#	doMouse2RequestRaycast = true
	#	raycastEvent = event
	#	print(event)

func attemptPickup(item, hitbox, mesh):
	if heldItem == null:
		updateHeldItem(item, hitbox, mesh)

func updateHeldItem(item, hitbox, mesh):
	hitbox.disabled = true
	heldItem = item
	heldHitbox = hitbox
	get_node("/root/Node3D/HUD/Label_HeldItem").text = heldItem.getName()

func requestDropHeldItem(dropRequestor):
	if heldItem != null:
		dropHeldItem(dropRequestor)
	
func dropHeldItem(dropRequestor):
	$Hand/HeldItem.mesh = null
	heldHitbox.disabled = false
	heldItem.position = dropRequestor.global_position
	heldItem = null
	heldHitbox = null
	get_node("/root/Node3D/HUD/Label_HeldItem").text = "no held item"

func getHeldItem():
	return heldItem

func getRaycastResult():
	var camera3d = $Camera
	var from = camera3d.project_ray_origin(camera3d.get_viewport().size / 2)
	var to = from + camera3d.project_ray_normal(camera3d.get_viewport().size / 2) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
	query.collide_with_areas = true
	return get_world_3d().direct_space_state.intersect_ray(query)
