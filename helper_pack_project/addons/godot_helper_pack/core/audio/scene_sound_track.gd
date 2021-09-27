class_name SceneSoundTrack
extends Node

export (Array, String, FILE, "*.tscn, *.scn") var scenes
export var startup := false

var _scene_names := []

func _ready():
	for scene_file_path in scenes:
		var scene_name = StringUtil.get_file_name(scene_file_path)
		_scene_names.append(scene_name.replace("_", "").to_lower())
	
	if startup and _scene_names.size() > 0:
		check_scene_and_play(_scene_names[0])

func check_scene_and_play(scene_name: String) -> bool:
	if !_scene_names.has(scene_name.to_lower()):
		return false
	var played_sound := false
	for c in get_children():
		if c is AudioStreamPlayer or c is AudioStreamPlayer2D or c is AudioStreamPlayer3D:
			if !c.playing:
				c.play()
			played_sound = true
	return played_sound

func stop() -> void:
	for c in get_children():
		if c is AudioStreamPlayer or c is AudioStreamPlayer2D or c is AudioStreamPlayer3D:
			if c.playing:
				c.stop()



