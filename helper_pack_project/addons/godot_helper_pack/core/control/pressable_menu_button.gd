tool
class_name PressableMenuButton
extends MenuButton

signal id_pressed(id)
signal id_focused(id)

func _ready():
	pass
	var popup_menu := get_popup()
	popup_menu.connect("id_pressed", self, "_on_popup_menu_id_pressed")
	popup_menu.connect("id_focused", self, "_on_popup_menu_id_focused")


func _on_popup_menu_id_pressed(id):
	emit_signal("id_pressed", id)


func _on_popup_menu_id_focused(id):
	emit_signal("id_focused", id)
