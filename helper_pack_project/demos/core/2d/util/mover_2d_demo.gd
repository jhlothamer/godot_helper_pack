extends Node2D


onready var _mover2d: Mover2D = $Icon/Mover2D


func _on_FollowMouseChkBtn_toggled(button_pressed):
	_mover2d.follow_mouse = button_pressed

