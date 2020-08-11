tool
extends EditorPlugin

"""
This plugin exists for only one reason right now and that's to register the singletons
of the Godot Helper Pack.  If you do not wish to use these singletons then you may
leave the plugin disabled or disable the singletons on the AutoLoad tab in Project Settings.
This plugin does not remove the singletons it adds.
"""

func _enter_tree():
	add_autoload_singleton("Globals", "res://addons/godot_helper_pack/core/globals.gd")
	add_autoload_singleton("SignalMgr", "res://addons/godot_helper_pack/core/signal_mgr.gd")

