extends Node
class_name CameraLimiter

onready var camera: Camera2D = get_parent() if typeof(get_parent()) == typeof(Camera2D) else null


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
	SignalMgr.register_subscriber(self, "CameraLimit", "on_camera_limit")


func on_camera_limit(limit_rect: Rect2) -> void:
	if camera == null:
		return
	camera.limit_left = limit_rect.position.x
	camera.limit_top = limit_rect.position.y
	camera.limit_right = limit_rect.end.x
	camera.limit_bottom = limit_rect.end.y
