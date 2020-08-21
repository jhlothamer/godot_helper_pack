class_name StopWatch
extends Object

var _start_time : float
var _stop_time : float


func start():
	_start_time = OS.get_ticks_usec()
	_stop_time = _start_time

func stop():
	_stop_time = OS.get_ticks_usec()

func get_elapsed_usec():
	return _stop_time - _start_time

func get_elapsed_msec():
	return get_elapsed_usec() / 1000.0
