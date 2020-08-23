class_name MultiYield
extends Object

"""
Can wait for all or any
"""
enum Mode {
	ALL,
	ANY
}

"""
signal when all/any signals triggered
"""
signal completed()

"""
properties
"""
var yield_count: int = 0
var signaled_count: int = 0
var mode = Mode.ALL
var _coroutines := []


"""
constructor
accepts array of tuples (object, signal_name)
can also set mode (wait for All, or Any)
"""
func _init(mode: int = Mode.ALL):
	if mode != Mode.ALL:
		self.mode = Mode.ANY


"""
adds a signal to wait for
"""
func add(object: Object, signal_name: String = "completed") -> void:
	object.connect(signal_name, self, "_signaled")
	yield_count += 1


func add_coroutine(function_state: GDScriptFunctionState) -> void:
	_coroutines.append(function_state)


func wait_for_coroutines():
	for coroutine in _coroutines:
		if coroutine.is_valid():
			yield(coroutine, "completed")
			if mode == Mode.ANY:
				break
	reset()
	emit_signal("completed")


"""
method connected to signals to wait for
"""
func _signaled(_param1=null, _param2=null, _param3=null, _param4=null, _param5=null, _param6=null):
	signaled_count += 1
	if signaled_count >= yield_count || mode == Mode.ANY:
		reset()
		emit_signal("completed")


"""
reset yield multi so it can be used again.  Only with Mode.ALL is this required.
"""
func reset():
	signaled_count = 0
	yield_count = 0
	_coroutines.clear()

