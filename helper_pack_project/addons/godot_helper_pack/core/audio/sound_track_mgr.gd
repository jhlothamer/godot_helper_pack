class_name SoundTrackMgr
extends Node

var _current_scene_sound_track:SceneSoundTrack = null

func _ready():
	var _results = get_tree().connect("node_added", self, "_on_node_added")
	var current_scene = get_tree().get_current_scene()
	_on_node_added(current_scene)

func _on_node_added(node : Node):
	if node.get_parent() != get_tree().root:
		return
	var path = str(node.get_path())
	var scene_name = path.replace("/root/", "")
	_play_scene(scene_name)

func _play_scene(scene_name: String) -> void:
	for child in get_children():
		if !child is SceneSoundTrack:
			continue
		var sceneSoundTrack:SceneSoundTrack = child
		if sceneSoundTrack.check_scene_and_play(scene_name):
			if _current_scene_sound_track != sceneSoundTrack:
				if _current_scene_sound_track != null:
					_current_scene_sound_track.stop()
				_current_scene_sound_track = sceneSoundTrack
			return
	if _current_scene_sound_track != null:
		_current_scene_sound_track.stop()
		_current_scene_sound_track = null
