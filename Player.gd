extends CharacterBody3D

var doRequestRaycast = false
var raycastEvent
var RAY_LENGTH = 1000.0
var walk_speed = 2.0
var rotate_sensitivity_h = 1
var rotate_invert_h = -1
var heldItem = null
var heldHitbox = null

func _physics_process(_delta):
	# Object Picking
	if doRequestRaycast:
		var camera3d = $Camera
		var from = camera3d.project_ray_origin(raycastEvent.position)
		var to = from + camera3d.project_ray_normal(raycastEvent.position) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
		query.collide_with_areas = true
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		if (!result.is_empty() and result.collider.has_method("ping")):
			result.collider.ping()
		doRequestRaycast = false
	
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
	elif event is InputEventMouseButton and event.pressed and event.button_index == 1:
		doRequestRaycast = true
		raycastEvent = event
		print(event)

func attemptPickup(item, hitbox, mesh):
	if heldItem == null:
		updateHeldItem(item, hitbox, mesh)

func updateHeldItem(item, hitbox, mesh):
	item.visible = false
	hitbox.disabled = true
	heldItem = item
	heldHitbox = hitbox
	$Hand/HeldItem.mesh = mesh.mesh

func requestDropHeldItem(dropRequestor):
	if heldItem != null:
		dropHeldItem(dropRequestor)
	
func dropHeldItem(dropRequestor):
	$Hand/HeldItem.mesh = null
	heldHitbox.disabled = false
	heldItem.visible = true
	heldItem.position = dropRequestor.global_position
	heldItem = null
	heldHitbox = null
