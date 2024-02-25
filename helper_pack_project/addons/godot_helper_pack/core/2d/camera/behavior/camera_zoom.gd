## This node zooms its parent Camera2D. By default it does this by scrolling
## the mouse wheel up (zoom in) or down (zoom out), but you can give it
## action names to use different inputs or to add more.
@tool
extends Node
class_name CameraZoom2D


## The amount of zoom applied to the parent Camera2D each time
## the mouse wheel is scrolled or the zoom actions are triggered.
@export var zoom_speed = .25
## The minimum amount of zoom applied to the parent Camera2D.
@export var min_camera_zoom: float = .25
## The maximum amount of zoom applied to the parent Camera2D.
@export var max_camera_zoom: float = 10.0
## The name of the input action for zooming in the parent Camera2D.
## If blank, then scrolling the mouse wheel up will trigger the zoom in.
@export var zoom_in_action_name := ""
## The name of the input action for zooming out the parent Camera2D.
## If blank, then scrolling the mouse wheel down will trigger the zoom out.
@export var zoom_out_action_name := ""


@onready var _camera: Camera2D = get_parent() if typeof(get_parent()) == typeof(Camera2D) else null


func _ready() -> void:
	if Engine.is_editor_hint():
		set_process_input(false)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if !get_parent() is Camera2D:
		warnings = ['CameraShake2D must be child of Camera2D']
	return warnings


func _input(event):
	if !event is InputEventMouseButton || _camera == null:
		return
	var delta = 0
	if zoom_out_action_name:
		if event.is_action(zoom_out_action_name):
			delta = -zoom_speed
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		delta = -zoom_speed

	if zoom_in_action_name:
		if event.is_action(zoom_in_action_name):
			delta = zoom_speed
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
		delta = zoom_speed
	
	var zoom = _camera.zoom.x
	zoom = clamp( zoom + delta, min_camera_zoom, max_camera_zoom)
	_camera.zoom = Vector2(zoom, zoom)
