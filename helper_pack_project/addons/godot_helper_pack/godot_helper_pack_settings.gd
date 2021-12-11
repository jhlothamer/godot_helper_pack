tool
class_name GodotHelperPackSettings
extends Object


const PROJECT_SETTING_GLOBAL_BLOCKING_COLOR_KEY = "godot_helper_pack_plugin/blocking_global_color"


static func get_global_blocking_color() -> Color:
	if !ProjectSettings.has_setting(PROJECT_SETTING_GLOBAL_BLOCKING_COLOR_KEY):
		ProjectSettings.set_setting(PROJECT_SETTING_GLOBAL_BLOCKING_COLOR_KEY, Color.white)
	return ProjectSettings.get_setting(PROJECT_SETTING_GLOBAL_BLOCKING_COLOR_KEY)

