class_name YieldUtil
extends Reference

signal completed()

var _wait_all := false
var _wait_all_count := 0
var _signaled_count := 0

func _init(wait_all: bool = false) -> void:
	_wait_all = wait_all


func add(object: Object, signal_name: String = "completed"):
	_wait_all_count += 1
	if object is GDScriptFunctionState:
		object.connect("completed", self, "_signaled")
	else:
		object.connect(signal_name, self, "_signaled")


func remove(object: Object, signal_name: String = "completed"):
	_wait_all_count += 1
	if object is GDScriptFunctionState:
		object.disconnect("completed", self, "_signaled")
	else:
		object.disconnect(signal_name, self, "_signaled")


func _signaled(_param1=null, _param2=null, _param3=null, _param4=null, _param5=null, _param6=null):
	if !_wait_all:
		emit_signal("completed")
		return
	_signaled_count += 1
	if _signaled_count >= _wait_all_count:
		emit_signal("completed")
