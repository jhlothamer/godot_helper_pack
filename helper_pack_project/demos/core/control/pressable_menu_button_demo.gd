extends Control


@onready var _output:TextEdit = %OutputTextEdit


func _add_output(msg: String) -> void:
	_output.text += "\n%s" % msg


func _on_pressable_menu_button_id_focused(id: int) -> void:
	_add_output("id_focused: %d" % id)


func _on_pressable_menu_button_id_pressed(id: int) -> void:
	_add_output("id_pressed: %d" % id)


func _on_clear_output_btn_pressed():
	_output.text = ""
