class_name RotateIt
extends Node

@export var rotation_speed_degrees = rad_to_deg(.25*PI) :
	set(mod_value):
		rotation_speed_degrees= mod_value
		_rotation_speed = deg_to_rad(rotation_speed_degrees)
@export var clockwise := true

var _rotation_speed := 0.0

var _parent: Node2D
@onready var _clockwise: float = 1 if clockwise else -1


func _ready():
	self.rotation_speed_degrees = rotation_speed_degrees
	var temp = get_parent()
	if !temp is Node2D:
		printerr("RotateIt: parent must derived from Node2D")
		set_physics_process(false)
		return
	_parent = temp


func _physics_process(delta):
	_parent.rotate(_rotation_speed * delta * _clockwise)
