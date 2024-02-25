## This node moves it's parent Camera2D. It uses actions defined in the input map for up, down, left
## and right. You can also set it to move the mouse via clicking and dragging the mouse.
@tool
extends Node
class_name CameraMove2D

signal camera_pan_started()
signal camera_pan_stopped()

## The speed of camera movement in pixels/second.
@export var move_speed: float = 10
## The input action name used to detect when to move the camera in the up direction.
@export var up_action_name := "ui_up"
## The input action name used to detect when to move the camera in the down direction.
@export var down_action_name := "ui_down"
## The input action name used to detect when to move the camera in the left direction.
@export var left_action_name := "ui_left"
## The input action name used to detect when to move the camera in the right direction.
@export var right_action_name := "ui_right"
## Flag to enable movement by clicking and dragging with the right mouse button.
@export var right_mouse_button_drag := false
## Flag to enable movement by clicking and dragging with the left mouse button.
@export var left_mouse_button_drag := false
## Flag to enable movement by clicking and dragging with the middle mouse button.
@export var middle_mouse_button_drag := false


@onready var _camera: Camera2D = get_parent() if typeof(get_parent()) == typeof(Camera2D) else null


var _is_dragging := false


func _ready():
	if _camera == null or Engine.is_editor_hint():
		set_process(false)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if !get_parent() is Camera2D:
		warnings = ['CameraMove2D must be child of Camera2D']
	return warnings


func _get_move_direction() -> Vector2:
	var move_direction = Vector2.ZERO
	
	if Input.is_action_pressed(up_action_name):
		move_direction += Vector2.UP
	if Input.is_action_pressed(down_action_name):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed(left_action_name):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed(right_action_name):
		move_direction += Vector2.RIGHT
	
	if move_direction.x != 0.0 and move_direction.y != 0.0:
		move_direction = move_direction.normalized()
	
	return move_direction


func _process(_delta):
	var move_direction = _get_move_direction()
	
	if move_direction == Vector2.ZERO:
		return

	move_direction *= move_speed * (1.0 / _camera.zoom.x)

	var limit_check_offset: Vector2 = Vector2.ZERO
	var limit_check_top_left: Vector2 = Vector2.ZERO
	var limit_check_bottom_right: Vector2 = Vector2.ZERO
	if _camera.anchor_mode == Camera2D.ANCHOR_MODE_DRAG_CENTER:
		limit_check_offset = get_viewport().get_visible_rect().size / 2.0
	
	limit_check_top_left = Vector2(_camera.limit_left + limit_check_offset.x, _camera.limit_top
		+ limit_check_offset.y)
	limit_check_bottom_right = Vector2(_camera.limit_right - limit_check_offset.x, _camera.limit_bottom
		- limit_check_offset.y)
	
	var new_camera_global_position = Vector2Util.clampv(_camera.global_position + move_direction, 
		limit_check_top_left, limit_check_bottom_right)
	
	_camera.global_position = new_camera_global_position


func _is_drag_enabled():
	return right_mouse_button_drag || left_mouse_button_drag || middle_mouse_button_drag


func _unhandled_input(event):
	if !event is InputEventMouse || !_is_drag_enabled():
		return
	if event is InputEventMouseButton:
		_handle_mouse_button_event(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion_event(event)


func _handle_mouse_button_event(event: InputEventMouseButton) -> void:
	if _is_dragging && !event.pressed:
		_is_dragging = false
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		emit_signal("camera_pan_stopped")
		return
	if event.button_index == MOUSE_BUTTON_LEFT && left_mouse_button_drag:
		_is_dragging = true
	elif event.button_index == MOUSE_BUTTON_RIGHT && right_mouse_button_drag:
		_is_dragging = true
	if event.button_index == MOUSE_BUTTON_MIDDLE && middle_mouse_button_drag:
		_is_dragging = true
	if _is_dragging:
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		emit_signal("camera_pan_started")


func _handle_mouse_motion_event(event: InputEventMouseMotion) -> void:
	if !_is_dragging:
		return
	_camera.global_position -= event.relative * (1.0 / _camera.zoom.x)
