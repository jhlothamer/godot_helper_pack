class_name Mover2D
extends Node

export (float, .1, 10000.0) var movement_speed := 400.0
export var up_action_name := "ui_up"
export var down_action_name := "ui_down"
export var left_action_name := "ui_left"
export var right_action_name := "ui_right"
export var follow_mouse := false

onready var _node2d_parent: Node2D = get_parent()


func _ready():
	if !_node2d_parent:
		printerr("Move2D: parent must be Node2D")
		queue_free()


func _physics_process(delta):
	if follow_mouse:
		_node2d_parent.global_position = _node2d_parent.get_global_mouse_position()
		return
	
	var move_direction = _get_move_direction()
	
	if move_direction == Vector2.ZERO:
		return
	
	if _node2d_parent is KinematicBody2D:
		_node2d_parent.move_and_slide(move_direction * movement_speed)
	else:
		_node2d_parent.global_position += move_direction * movement_speed * delta


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
