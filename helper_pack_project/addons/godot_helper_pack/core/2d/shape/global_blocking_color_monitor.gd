@tool
extends Node

@onready var _timer:Timer = $ChangeCheckTimer


var _prev_color: Color


func _ready():
	if !Engine.is_editor_hint():
		_timer.stop()
	_prev_color = GodotHelperPackSettings.get_global_blocking_color()


func _on_ChangeCheckTimer_timeout():
	var curr_color = GodotHelperPackSettings.get_global_blocking_color()
	if curr_color != _prev_color:
		_prev_color = curr_color
		print("color changed - calling update")
		get_tree().call_group("blocking_block", "update_from_global_blocking_color", curr_color)
