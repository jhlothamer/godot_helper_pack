class_name CameraLimiter2D
extends Node

@export var limit_reference_rect: NodePath


var _camera: Camera2D

func _enter_tree():
	ServiceMgr.register_service(CameraLimiter2D, self)


func _ready():
	var parent = get_parent()
	if parent is Camera2D:
		_camera = parent
	if limit_reference_rect != null:
		var limit_reference_rect_node = get_node_or_null(limit_reference_rect)
		if limit_reference_rect_node != null and limit_reference_rect_node is ReferenceRect:
			var limit_rect := Rect2(limit_reference_rect_node.global_position, limit_reference_rect_node.size)
			limit_camera(limit_rect)


func limit_camera(limit_rect: Rect2) -> void:
	if _camera == null:
		return
	_camera.limit_left = int(limit_rect.position.x)
	_camera.limit_top = int(limit_rect.position.y)
	_camera.limit_right = int(limit_rect.end.x)
	_camera.limit_bottom = int(limit_rect.end.y)
	_camera.align()
