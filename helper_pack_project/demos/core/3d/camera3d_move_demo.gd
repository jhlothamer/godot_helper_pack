extends Node3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event.is_pressed() and event is InputEventKey:
		var ek: InputEventKey = event
		if ek.keycode == KEY_ESCAPE:
			if null == get_tree().root.get_node_or_null("DemoHud"):
				get_tree().quit()
				return
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
