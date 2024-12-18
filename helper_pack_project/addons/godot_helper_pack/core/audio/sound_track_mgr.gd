## Changes what sound track is played based on what the current scene is.
## To configure what scenes go with what sound tracks, add SceneSoundTrack nodes
## as children.
## Please see wiki page for more instructions:
## https://github.com/jhlothamer/godot_helper_pack/wiki/SoundTrackMgr,-SceneSoundTrack

class_name SoundTrackMgr
extends Node


var _current_scene_sound_track:SceneSoundTrack = null


func _ready():
	var _results = get_tree().node_added.connect(_on_node_added)
	var current_scene = get_tree().get_current_scene()
	_on_node_added(current_scene)


func _on_node_added(node : Node):
	if node.get_parent() != get_tree().root or node.scene_file_path.is_empty():
		return
	_play_scene(node.scene_file_path)


func _play_scene(file_path: String) -> void:
	for child in get_children():
		if !child is SceneSoundTrack:
			continue
		var sceneSoundTrack:SceneSoundTrack = child
		if sceneSoundTrack.check_scene_and_play(file_path):
			if _current_scene_sound_track != sceneSoundTrack:
				if _current_scene_sound_track != null:
					_current_scene_sound_track.stop()
				_current_scene_sound_track = sceneSoundTrack
			return
	if _current_scene_sound_track != null:
		_current_scene_sound_track.stop()
		_current_scene_sound_track = null
