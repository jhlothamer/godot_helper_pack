extends State

var change_to_state: String = ""
var init_called := false
var enter_called := false
var exit_called := false
var physics_process_called := false

func init(state_machine_, host_):
	.init(state_machine_, host_)
	init_called = true


func enter() -> void:
	enter_called = true


func exit() -> void:
	exit_called = true


func physics_process(delta) -> void:
	physics_process_called = true
	if change_to_state != "":
		change_state(change_to_state)
