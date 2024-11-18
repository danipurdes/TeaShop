extends Node3D

@export_range(-180,180,15) var open_angle_degrees = -75
@export_range(0,5,0.1) var opening_duration:float = 0.5

@onready var closed_angle_degrees = rotation_degrees.y

var tween

func _ready():
	$Area3D.body_entered.connect(open_door)
	$Area3D.body_exited.connect(close_door)

func open_door(_body):
	print_debug("open haha")
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Model, "rotation:y", deg_to_rad(open_angle_degrees), opening_duration)

func close_door(_body):
	print_debug("close haha")
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Model, "rotation:y", deg_to_rad(0), opening_duration)
