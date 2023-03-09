# Replacement for GDScriptFunctionState that no longer exists in Godot 4.
# How does it work?
# 1. create an instance giving it the Callable to call
# 2. call the run function, passing in any arguments as an array
# 3. call is_completed() to see if the function has already completed
#	If this is already true - then the Callable didn't await - which may or may not be an error
# 4. await on completed signal (but only if not already completed - see step 3)
# 5. Check if there was an error by calling success()
# 6. If successful then obtain the results by calling get_results()
#		If no return value was returned, this will be null
class_name Yield
extends RefCounted

signal completed()


var _coroutine: Callable
var _results
var _success := false
var _is_completed := false


func _init(coroutine: Callable) -> void:
	_coroutine = coroutine


func run(arguments: Array = []) -> void:
	_success = false
	_is_completed = false
	_results = null

	var error_check_value = await _inner_run(arguments)

	if error_check_value == 1:
		_success = true

	completed.emit()
	_is_completed = true


func _inner_run(arguments: Array):
	_results = await _coroutine.callv(arguments)
	return 1


func get_results():
	return _results


func success() -> bool:
	return _success


func is_completed() -> bool:
	return _is_completed

