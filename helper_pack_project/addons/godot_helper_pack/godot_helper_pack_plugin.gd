tool
extends EditorPlugin

const SCENE_PATH_BLOCKING_BLOCK = "res://addons/godot_helper_pack/core/2d/shape/blocking_block_2d.tscn"
const DISTRIBUTION_EDITOR_PLUGIN_SCENE = preload("res://addons/godot_helper_pack/core/2d/util/distribution/distribution_editor_plugin.tscn")

const HELPER_PACK_AUTOLOADS = {
	"Globals": "res://addons/godot_helper_pack/core/globals.gd",
	"SignalMgr": "res://addons/godot_helper_pack/core/signal_mgr.gd",
	"ServiceMgr": "res://addons/godot_helper_pack/core/service_mgr.gd",
	"GlobalBlockingColorChangeMonitor": "res://addons/godot_helper_pack/core/2d/shape/global_blocking_color_monitor.tscn",
}

var _distribution_editor: DistributionEditorPlugin
var _distribution_editor_tool_btn: ToolButton

func _enter_tree():
	# force addition of color setting
	var _discard = GodotHelperPackSettings.get_global_blocking_color()
	
	for autoload_name in HELPER_PACK_AUTOLOADS.keys():
		add_autoload_singleton(autoload_name, HELPER_PACK_AUTOLOADS[autoload_name])
	
	var editor_interface = get_editor_interface()
	
	_add_remove_blocking_block_favorite(true, editor_interface.get_editor_settings())
	
	_add_distribution_editor()


func _exit_tree():
	var editor_interface = get_editor_interface()
	
	_add_remove_blocking_block_favorite(false, editor_interface.get_editor_settings())
	
	_remove_distribution_editor()

	var autoloads = _get_autoloads()
	for autoload_name in HELPER_PACK_AUTOLOADS.keys():
		if autoloads.has(autoload_name):
			remove_autoload_singleton(autoload_name)


func _add_remove_blocking_block_favorite(add: bool, editor_settings: EditorSettings) -> void:
	var favorites = editor_settings.get_favorites()
	var i = 0
	var index = -1
	for fav in favorites:
		if fav == SCENE_PATH_BLOCKING_BLOCK:
			index = i
			break
		i += 1
	
	if !add and index >= 0:
		favorites.remove(index)
		editor_settings.set_favorites(favorites)
	elif add and index < 0:
		favorites.append(SCENE_PATH_BLOCKING_BLOCK)
		editor_settings.set_favorites(favorites)


func _get_autoloads() -> Array:
	var autoloads = []
	for p in ProjectSettings.get_property_list():
		var s: String = p.name
		if s.begins_with("autoload/"):
			autoloads.append(s.replace("autoload/", ""))
	return autoloads


func _add_distribution_editor() -> void:
	if !_distribution_editor:
		_distribution_editor = DISTRIBUTION_EDITOR_PLUGIN_SCENE.instance()

	_distribution_editor_tool_btn = add_control_to_bottom_panel(_distribution_editor, "Distribution")
	_distribution_editor_tool_btn.visible = false
	

func _remove_distribution_editor() -> void:
	if !_distribution_editor:
		return
	remove_control_from_bottom_panel(_distribution_editor)
	_distribution_editor_tool_btn = null


func edit(object: Object) -> void:
	if _distribution_editor:
		_distribution_editor.edit(object)


func handles(object: Object) -> bool:
	if object is MultiMeshInstanceDistributionArea or object is RandomDistributionArea:
		return true
	if _distribution_editor:
		_distribution_editor.clear()
	return false


func make_visible(visible: bool) -> void:
	_distribution_editor_tool_btn.visible = visible


