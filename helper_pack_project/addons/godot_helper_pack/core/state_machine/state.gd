extends Node
class_name State

export var is_starting_state : bool

var state_machine: StateMachine
var host


func init(state_machine_, host_):
	state_machine = state_machine_
	host = host_


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics_process(delta) -> void:
	pass


func unhandled_input(event: InputEvent) -> void:
	pass


func change_state(state_name) -> void:
	state_machine.change_state(state_name)
