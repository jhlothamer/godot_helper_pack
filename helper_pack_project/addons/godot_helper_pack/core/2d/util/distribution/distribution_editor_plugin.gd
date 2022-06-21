tool
class_name DistributionEditorPlugin
extends MarginContainer

onready var _please_select_label: Label = $CenterContainer/Label
onready var _main_ui: VBoxContainer = $VBoxContainer
onready var _status_txt: TextEdit = $VBoxContainer/StatusTextEdit
onready var _mmi_dis_area_menus := [
	$VBoxContainer/MenuHBoxContainer/DistributeMenuBtn,
	$VBoxContainer/MenuHBoxContainer/CollisionPolygonsMenuBtn
]
onready var _rand_dist_area_menus := [
	$VBoxContainer/MenuHBoxContainer/RandDistArealDistributeMenuBtn
]

var _curr_mmi_dist_area: MultiMeshInstanceDistributionArea
var _curr_rand_dist_area: RandomDistributionArea


func edit(object: Object) -> void:
	if object is MultiMeshInstanceDistributionArea:
		_curr_mmi_dist_area = object
	elif object is RandomDistributionArea:
		_curr_rand_dist_area = object
	_update_ui()
	
	_please_select_label.visible = false
	_main_ui.visible = true

func _update_ui():
	if !_curr_mmi_dist_area and !_curr_rand_dist_area:
		clear()
		return
	_please_select_label.visible = false
	_main_ui.visible = true
	for m in _mmi_dis_area_menus:
		m.visible = _curr_mmi_dist_area != null
	for m in _rand_dist_area_menus:
		m.visible = _curr_rand_dist_area != null
	


func clear():
	_please_select_label.visible = true
	_curr_mmi_dist_area = null
	_curr_rand_dist_area = null
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


func _on_RandDistArealDistributeMenuBtn_id_pressed(id: int) -> void:
	if !_curr_rand_dist_area:
		return
	match id:
		0:
			_status_txt.text = "Starting distribution.  This could take a while."
			_curr_rand_dist_area.connect("status_updated", self, "_on_status_updated")
			_curr_rand_dist_area.do_distribution()
			yield(_curr_rand_dist_area, "operation_completed")
			print("DistributionEditorPlugin: distribution operation completed")
			_curr_rand_dist_area.disconnect("status_updated", self, "_on_status_updated")
			_status_txt.text = _curr_rand_dist_area.status
		1:
			_curr_rand_dist_area.clear_distribution()
			_status_txt.text = "Distribution cleared"


func _on_status_updated(status_text: String) -> void:
		_status_txt.text = status_text
