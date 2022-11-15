class_name WaitAny
extends RefCounted


signal completed()


var _completed := false


func add(s: Signal) -> void:
	if s.is_connected(self._signal_handler):
		return
	s.connect(self._signal_handler)


func remove(s: Signal) -> void:
	if !s.is_connected(self._signal_handler):
		return
	s.disconnect(self._signal_handler)


func reset() -> void:
	_completed = false


func _signal_handler(_p0 = null, _p1 = null, _p2 = null, _p3 = null, _p4 = null, _p5 = null, _p6 = null, _p7 = null, _p8 = null, _p9 = null) -> void:
	if _completed:
		return
	_completed = true
	emit_signal("completed")

