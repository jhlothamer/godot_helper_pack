extends Node
class_name StateMachine, "state_machine.svg"



export var debug : bool
export var disabled : bool
export var host_node: NodePath


var _current_state = null
var _host: Node
var _required_state_node_methods: Array = [
	"init", "enter", "exit" , "physics_process", "unhandled_input", "change_state"]
var _prohibited_state_node_methods: Array = ["_physics_process"]


func _ready():
	yield(get_parent(), "ready")

	if host_node != null && !host_node.is_empty() && has_node(host_node):
		_host = get_node(host_node)
	else:
		_host = get_parent()

	var found_problems: bool = false
	for child in get_children():
		found_problems = _check_state_node(child) || found_problems
		child.init(self, _host)
		if child.is_starting_state:
			_current_state = child
	if _current_state != null:
		_print_dbg("starting state is " + _current_state.name)
		_current_state.enter()
	else:
		push_error("No starting state designated for state machine.")
		assert(false)

	if found_problems:
		assert(false)


func _check_state_node(state_node: Node) -> bool:
	var problem_found: bool = false

	#check that it has these methods - indicates it extends State
	for required_method in _required_state_node_methods:
		if !state_node.has_method(required_method):
			push_error("state node " + state_node.name + " is missing method " + required_method)
			problem_found = true

	#check that it does not have these methods - they will just cause problems
	for prohibited_method in _prohibited_state_node_methods:
		if state_node.has_method(prohibited_method):
			push_error("state node %s has method %s and it should not" % [state_node.name,
				prohibited_method])
			problem_found = true

	return problem_found


func change_state(state_name) -> void:
	if _current_state != null:
		_print_dbg("exiting state " + _current_state.name)
		_current_state.exit()
	assert(has_node(state_name))
	_current_state = get_node(state_name)
	_print_dbg("entering state " + _current_state.name)
	_current_state.enter()


func _physics_process(delta) -> void:
	if disabled:
		return
	if _current_state != null:
		_current_state.physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if _current_state != null:
		_current_state.unhandled_input(event)


func _print_dbg(msg):
	if !debug:
		return
	print(str(OS.get_ticks_msec()) + ": " + msg)
