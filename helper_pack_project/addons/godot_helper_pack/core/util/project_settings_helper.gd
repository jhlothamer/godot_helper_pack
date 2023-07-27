extends Object

class_name ProjectSettingsHelper

static func get_physics_process_delta() -> float:
	return 1.0 / convert(ProjectSettings.get_setting("physics/common/physics_ticks_per_second"), TYPE_FLOAT)


static func get_audio_channel_disable_threshold_db() -> float:
	return convert(ProjectSettings.get("audio/buses/channel_disable_threshold_db"), TYPE_FLOAT)
