extends Node
class_name CameraLimiter

export var limit_reference_rect: NodePath

onready var camera: Camera2D


static func enable_camera_limit(limiter: Object):
	assert(limiter != null)
	if !limiter.has_user_signal("CameraLimit"):
		limiter.add_user_signal("CameraLimit", [ 
		{ "name": "limit_rect", "type": TYPE_RECT2}
		])
		SignalMgr.register_publisher(limiter, "CameraLimit")


static func limit_camera(limiter: Object, limit_rect: Rect2):
	limiter.emit_signal("CameraLimit", limit_rect)


func _ready():
	SignalMgr.register_subscriber(self, "CameraLimit", "_on_camera_limit")
	var parent = get_parent()
	if parent is Camera2D:
		camera = parent
	if limit_reference_rect != null:
		var limit_reference_rect_node = get_node_or_null(limit_reference_rect)
		if limit_reference_rect_node != null and limit_reference_rect_node is ReferenceRect:
			var limit_rect := Rect2(limit_reference_rect_node.rect_global_position, limit_reference_rect_node.rect_size)
			_on_camera_limit(limit_rect)


func _on_camera_limit(limit_rect: Rect2) -> void:
	if camera == null:
		return
	camera.limit_left = limit_rect.position.x
	camera.limit_top = limit_rect.position.y
	camera.limit_right = limit_rect.end.x
	camera.limit_bottom = limit_rect.end.y
	camera.align()
