extends "res://addons/gut/test.gd"


func test_get_audio_channel_disable_threshold_db():
	var results = ProjectSettingsHelper.get_audio_channel_disable_threshold_db()
	assert_eq(results, -60)


func test_get_audio_channel_dxisable_threshold_db():
	var results = ProjectSettingsHelper.get_physics_process_delta()
	assert_eq(results, 1.0/60.0)


