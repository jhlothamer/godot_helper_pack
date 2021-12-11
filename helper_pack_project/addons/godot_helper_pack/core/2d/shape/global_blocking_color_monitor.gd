tool
extends Node


var _prev_color: Color


func _ready():
	if !Engine.editor_hint:
		queue_free()
	_prev_color = GodotHelperPackSettings.get_global_blocking_color()


func _on_ChangeCheckTimer_timeout():
	var curr_color = GodotHelperPackSettings.get_global_blocking_color()
	if curr_color != _prev_color:
		_prev_color = curr_color
		get_tree().call_group("blocking_block", "update_from_global_blocking_color", curr_color)
