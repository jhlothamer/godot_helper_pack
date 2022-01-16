extends Node
class_name CameraZoom2D


export var zoom_speed = .25
export var min_camera_zoom: float = .25
export var max_camera_zoom: float = 10.0
export var zoom_in_action_name := ""
export var zoom_out_action_name := ""

onready var _camera: Camera2D = get_parent() if typeof(get_parent()) == typeof(Camera2D) else null


func _input(event):
	if !event is InputEventMouseButton || _camera == null:
		return
	var delta = 0
	if zoom_out_action_name:
		if event.is_action(zoom_out_action_name):
			delta = zoom_speed
	if event.button_index == BUTTON_WHEEL_DOWN:
		delta = zoom_speed

	if zoom_in_action_name:
		if event.is_action(zoom_in_action_name):
			delta = -zoom_speed
	elif event.button_index == BUTTON_WHEEL_UP:
		delta = -zoom_speed
	
	var zoom = _camera.zoom.x
	zoom = clamp( zoom + delta, min_camera_zoom, max_camera_zoom)
	_camera.zoom = Vector2(zoom, zoom)
