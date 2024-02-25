## A state of the StateMachine.  Note that noe of the process functions are
## enabled.  (_physics_process, _process, _input, _unhandled_input, etc.)
## You must override the functions defined in the State script instead.
## This allows the StateMachine to control processing.
@icon("state.svg") 
extends Node
class_name State

## Flags the state as the starting state.  Exactly one state
## must have this flag set.
@export var is_starting_state : bool


var state_machine: StateMachine
var host


func _ready():
	set_physics_process(false)
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)


## Called by state machine so states can initialize themselves.
## If this function is overriden, be sure to call the base version
## with super(state_machine, host)
func init(_state_machine: StateMachine, _host: Node) -> void:
	state_machine = _state_machine
	host = _host


## called when state becomes the current state.  Override to perform any logic
## that must be done everytime this happens.
func enter() -> void:
	pass


## called when the state is re-entered.  This happens when a
## pushed state pops itself from the stack and this state
## becomes the current state again.  Override to perform any
## logic that must be done on re-enter.
func reenter(_from_state: String) -> void:
	pass


## called whenever the state is no longer the current state.
func exit() -> void:
	pass


## called every physics frame so long this state is the current
## state.  Override and perform any logic that must be done
## each physics frame, including any state changing.
func physics_process(_delta: float) -> void:
	pass


## Called whenever there is an unhandled input so long as this
## state is the current state.  Override this function to
## handle these inputs.
func unhandled_input(_event: InputEvent) -> void:
	pass


## Calls StateMachine's change_state function.  Do NOT override.
func change_state(state_name: String) -> void:
	state_machine.change_state(state_name)


## Calls StateMachine's pop_state function.  Do NOT override.
func pop_state() -> void:
	state_machine.pop_state()

## Calls StateMachine's push_state function.  Do NOT override.
func push_state(state_name: String) -> void:
	state_machine.push_state(state_name)

