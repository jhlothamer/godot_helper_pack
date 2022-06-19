tool
class_name DistributionEditorPlugin
extends MarginContainer

onready var _please_select_label: Label = $CenterContainer/Label
onready var _main_ui: VBoxContainer = $VBoxContainer
onready var _status_txt: TextEdit = $VBoxContainer/StatusTextEdit

var _curr_mmi_dist_area: MultiMeshInstanceDistributionArea


func edit(object: Object) -> void:
	if !object is MultiMeshInstanceDistributionArea:
		clear()
		return
	_please_select_label.visible = false
	_main_ui.visible = true
	_curr_mmi_dist_area = object

func clear():
	_please_select_label.visible = true
	_curr_mmi_dist_area = null
	_main_ui.visible = false


func _on_DistributeMenuBtn_id_pressed(id: int) -> void:
	if !_curr_mmi_dist_area:
		return
	match id:
		0:
			_status_txt.text = "Starting distribution.  This could take a while."
			_curr_mmi_dist_area._do_distribution()
			yield(_curr_mmi_dist_area, "operation_completed")
			_status_txt.text = _curr_mmi_dist_area.status
		1:
			_curr_mmi_dist_area._clear_distribution()
			_status_txt.text = "Distribution cleared"
		2:
			pass
			#calc radius
			_curr_mmi_dist_area._calc_compact_distribution_radius()
			_status_txt.text = _curr_mmi_dist_area.status
	


func _on_CollisionPolygonsMenuBtn_id_pressed(id: int) -> void:
	if !_curr_mmi_dist_area:
		return
	match id:
		0:
			_status_txt.text = ""
			_curr_mmi_dist_area._generate_static_body_collision_shapes()
			yield(_curr_mmi_dist_area, "operation_completed")
			_status_txt.text = _curr_mmi_dist_area.status
		1:
			_curr_mmi_dist_area._clear_static_body_collision_shapes()
			_status_txt.text = "Collision polygons cleared"
