extends Node
class_name CameraMove2D


export var move_speed: float = 10


onready var camera: Camera2D = get_parent() if typeof(get_parent()) == typeof(Camera2D) else null


func _ready():
	if camera == null:
		set_process(false)


func _get_move_direction() -> Vector2:
	var move_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		move_direction += Vector2.RIGHT
	
	if move_direction.x != 0.0 and move_direction.y != 0.0:
		move_direction = move_direction.normalized()
	
	return move_direction



func _process(_delta):
	var move_direction = _get_move_direction()
	
	if move_direction == Vector2.ZERO:
		return
	
	move_direction *= move_speed * camera.zoom.x

	var limit_check_offset: Vector2 = Vector2.ZERO
	var limit_check_top_left: Vector2 = Vector2.ZERO
	var limit_check_bottom_right: Vector2 = Vector2.ZERO
	if camera.anchor_mode == Camera2D.ANCHOR_MODE_DRAG_CENTER:
		limit_check_offset = get_viewport().get_visible_rect().size / 2.0
	
	limit_check_top_left = Vector2(camera.limit_left + limit_check_offset.x, camera.limit_top
		+ limit_check_offset.y)
	limit_check_bottom_right = Vector2(camera.limit_right - limit_check_offset.x, camera.limit_bottom
		- limit_check_offset.y)
	
	var new_camera_global_position = Vector2Util.clamp(camera.global_position + move_direction, 
		limit_check_top_left, limit_check_bottom_right)
	
	camera.global_position = new_camera_global_position
