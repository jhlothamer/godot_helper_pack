extends GutTest

var state_class
var state_machine

func before_each():
	if state_class == null:
		state_class = load("res://test/unit/core/state_machine/a.gd")
	if state_machine != null:
		remove_child(state_machine)
		state_machine.queue_free()
	
	state_machine = StateMachine.new()
	var a: State = state_class.new()
	a.name = "A"
	a.is_starting_state = true
	state_machine.add_child(a)
	var b: State = state_class.new()
	b.name = "B"
	state_machine.add_child(b)

	add_child(state_machine)
	emit_signal("ready")

func after_each():
	state_machine.queue_free()


func test_initial_state_functions_called():
	var a = state_machine.get_node("A")
	gut.simulate(state_machine, 1, .1)
	assert_true(a.init_called)
	assert_true(a.enter_called)
	assert_false(a.exit_called)
	assert_true(a.physics_process_called)
	var b = state_machine.get_node("B")
	assert_true(b.init_called)
	assert_false(b.enter_called)
	assert_false(b.exit_called)
	assert_false(b.physics_process_called)

func test_transition_to_state_b():
	var a = state_machine.get_node("A")
	a.change_to_state = "B"
	gut.simulate(state_machine, 1, .1)
	assert_true(a.init_called)
	assert_true(a.enter_called)
	assert_true(a.exit_called)
	assert_true(a.physics_process_called)
	var b = state_machine.get_node("B")
	assert_true(b.init_called)
	assert_true(b.enter_called)
	assert_false(b.exit_called)
	assert_false(b.physics_process_called)
	gut.simulate(state_machine, 1, .1)
	assert_true(b.physics_process_called)
