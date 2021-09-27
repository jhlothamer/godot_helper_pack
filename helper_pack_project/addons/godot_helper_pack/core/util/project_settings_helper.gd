extends Node

class_name ProjectSettingsHelper

static func get_physics_process_delta() -> float:
	return 1.0 / float(ProjectSettings.get("physics/common/physics_fps"))


static func get_audio_channel_disable_threshold_db() -> float:
	return float(ProjectSettings.get("audio/channel_disable_threshold_db"))
