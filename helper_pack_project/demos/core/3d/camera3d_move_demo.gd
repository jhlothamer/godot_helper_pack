extends Spatial


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event.is_pressed() and event is InputEventKey:
		var ek: InputEventKey = event
		if ek.scancode == KEY_ESCAPE:
			get_tree().quit()
