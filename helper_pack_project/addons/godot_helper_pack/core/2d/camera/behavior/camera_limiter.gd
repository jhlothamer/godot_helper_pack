## The is node will set the limits on it's parent Camera2D. There are two ways to do this. 
## One is to set the Limit Reference Rect property to a ReferenceRect node. 
## The other is to obtain a reference to the CameraLimiter2D service and call the limit_camera() function.
@tool
class_name CameraLimiter2D
extends Node

## A ReferenceRect node that defines the limit rectangle.
## This is used to set the parent Camera2D's limits when the scene is loaded.
@export var limit_reference_rect: ReferenceRect


var _camera: Camera2D


func _enter_tree():
	if Engine.is_editor_hint():
		return
	ServiceMgr.register_service(CameraLimiter2D, self)


func _ready():
	if Engine.is_editor_hint():
		return
	var parent = get_parent()
	if parent is Camera2D:
		_camera = parent
	if limit_reference_rect:
		var limit_rect := Rect2(limit_reference_rect.global_position, limit_reference_rect.size)
		limit_camera(limit_rect)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if !get_parent() is Camera2D:
		warnings = ['CameraLimiter2D must be child of Camera2D']
	return warnings


## Sets the limit properties of the parent Camera2D.
## Use this function to set the limit after the scene has already loaded.
func limit_camera(limit_rect: Rect2) -> void:
	if !_camera:
		return
	_camera.limit_left = int(limit_rect.position.x)
	_camera.limit_top = int(limit_rect.position.y)
	_camera.limit_right = int(limit_rect.end.x)
	_camera.limit_bottom = int(limit_rect.end.y)
	_camera.align()
