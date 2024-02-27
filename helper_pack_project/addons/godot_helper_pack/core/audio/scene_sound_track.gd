## Used by a SoundTrackMgr node to map scenes to sound tracks.  Add the
## scene paths to the scenes array and an AudioStreamPlayer as a child to
## this node.
class_name SceneSoundTrack
extends Node


## list of scenes to play soundtrack for
@export var scenes: Array[PackedScene]
## Sound track plays automatically on start up.  Best use case for this is
## if your game has only one sound track.
@export var startup := false


var _scene_names := []


func _ready():
	for scene in scenes:
		_scene_names.append(scene.resource_path)
	
	if startup:
		_play_track()


func _play_track() -> bool:
	for c in get_children():
		if c is AudioStreamPlayer or c is AudioStreamPlayer2D or c is AudioStreamPlayer3D:
			if !c.playing:
				c.play()
			return true
	return false


func check_scene_and_play(scene_file_path: String) -> bool:
	if !_scene_names.has(scene_file_path):
		return false
	return _play_track()

func stop() -> void:
	for c in get_children():
		if c is AudioStreamPlayer or c is AudioStreamPlayer2D or c is AudioStreamPlayer3D:
			if c.playing:
				c.stop()



