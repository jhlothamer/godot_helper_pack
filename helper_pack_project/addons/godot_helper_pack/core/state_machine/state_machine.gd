extends Node
class_name StateMachine, "state_machine.svg"



export var debug : bool
export var disabled : bool
export var host_node: NodePath


var _host: Node
var _required_state_node_methods: Array = [
	"init", "enter", "exit" , "physics_process", "unhandled_input", "change_state"]
var _prohibited_state_node_methods: Array = ["_physics_process"]


var _state_stack := []


func _ready():
	if disabled:
		return
	
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
			_state_stack.push_front(child)
	
	if _state_stack.empty():
		push_error("No starting state designated for state machine.")
		assert(false)
	elif _state_stack.size() > 1:
		push_error("Too many starting states for state machine.")
		assert(false)
	else:
		_print_dbg("starting state is %s" % _state_stack[0].name)
		_state_stack[0].enter()

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
	if !_state_stack.empty():
		_print_dbg("exiting state " + _state_stack[0].name)
		_state_stack[0].exit()
		
	assert(has_node(state_name))
	var new_state = get_node(state_name)
	if !_state_stack.empty():
		_state_stack[0] = new_state
	else:
		_state_stack.push_front(new_state)
	_print_dbg("entering state " + new_state.name)
	new_state.enter()


func push_state(state_name) -> void:
	assert(has_node(state_name))
	var new_state = get_node(state_name)
	_state_stack.push_front(new_state)
	_print_dbg("entering state " + new_state.name)
	new_state.enter()

func pop_state() -> void:
	assert(!_state_stack.empty())
	var state = _state_stack.pop_front()
	state.exit()
	if !_state_stack.empty():
		_state_stack[0].reenter(state.name)
	else:
		_print_dbg("StateMachine: no states after pop: %s" % get_path())


func _physics_process(delta) -> void:
	if disabled:
		return
	if !_state_stack.empty():
		_state_stack[0].physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if !_state_stack.empty():
		_state_stack[0].unhandled_input(event)


func _print_dbg(msg):
	if !debug:
		return
	print(str(OS.get_ticks_msec()) + ": " + msg)
