extends CanvasLayer


func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://demos/demos.tscn")
	queue_free()
