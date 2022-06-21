extends Node
class_name State, "state.svg"

export var is_starting_state : bool

var state_machine: StateMachine
var host

func _ready():
	set_physics_process(false)
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)


func init(_state_machine, _host):
	state_machine = _state_machine
	host = _host


func enter() -> void:
	pass

func reenter(from_state: String) -> void:
	pass


func exit() -> void:
	pass


func physics_process(delta: float) -> void:
	pass


func unhandled_input(event: InputEvent) -> void:
	pass


func change_state(state_name: String) -> void:
	state_machine.change_state(state_name)

func pop_state() -> void:
	state_machine.pop_state()

func push_state(state_name: String) -> void:
	state_machine.push_state(state_name)

