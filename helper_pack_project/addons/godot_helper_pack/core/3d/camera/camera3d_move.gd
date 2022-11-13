class_name Camera3DMove
extends Node

export (float, .1, 5) var move_speed: float = .1
export var mouse_sensitivity := 1.5
export var invert_mouse_y := false
export var forward_action_name := "ui_up"
export var back_action_name := "ui_down"
export var strafe_left_action_name := "ui_left"
export var strafe_right_action_name := "ui_right"
export var fly := false
export var up_action_name := "ui_page_up"
export var down_action_name := "ui_page_down"

onready var _camera: Camera = get_parent()

func _ready():
	if !_camera:
		printerr("Camera3DMove: parent must be Camera")
		queue_free()

func _input(event):
	if !event is InputEventMouseMotion:
		return
	var mm:InputEventMouseMotion = event
	var y_deg = rad2deg(_camera.rotation.y)
	y_deg -= mm.relative.x * mouse_sensitivity / 10.0
	#_camera.rotate_y(deg2rad(-mm.relative.x * mouse_sensitivity / 10.0))
	_camera.rotation.y = deg2rad(y_deg)
	var factor := 1.0 if invert_mouse_y else -1.0
	var x_deg = rad2deg(_camera.rotation.x)
	x_deg = clamp(x_deg + factor*mm.relative.y * mouse_sensitivity/10.0, -70.0, 70.0)
	_camera.rotation.x = deg2rad(x_deg)
	#_camera.rotate_z(deg2rad(x_deg) - _camera.rotation.z)




func _physics_process(delta):
	var h_rot = _camera.rotation.y
	var f_input = Input.get_action_strength(back_action_name) - Input.get_action_strength(forward_action_name)
	var h_input = Input.get_action_strength(strafe_right_action_name) - Input.get_action_strength(strafe_left_action_name)
	var v_input = Input.get_action_strength(up_action_name) - Input.get_action_strength(down_action_name)
	if f_input == 0 and h_input == 0 and v_input == 0:
		return
	var direction = Vector3(h_input, v_input, f_input).rotated(Vector3.UP, h_rot).normalized()
	_camera.global_translate(direction * move_speed)

