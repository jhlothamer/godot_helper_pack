@tool
class_name PressableMenuButton
extends MenuButton
## A menu button that exposes the underlying popup menu's id_pressed() and id_focused() signals
## so you don't have to write code to call get_popup() and connect to those signals.


signal id_pressed(id: int)
signal id_focused(id: int)

func _ready():
	var popup_menu := get_popup()
	popup_menu.id_pressed.connect(_on_popup_menu_id_pressed)
	popup_menu.id_focused.connect(_on_popup_menu_id_focused)


func _on_popup_menu_id_pressed(id: int) -> void:
	id_pressed.emit(id)


func _on_popup_menu_id_focused(id: int) -> void:
	id_focused.emit(id)
