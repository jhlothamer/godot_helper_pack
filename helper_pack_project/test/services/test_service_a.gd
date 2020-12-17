class_name TestServiceA
extends Node

var _test_service_a_foo_called_in := ""
var _test_service_a_bar_called_in := ""


func foo():
	_test_service_a_foo_called_in = "TestServiceA"


func bar():
	_test_service_a_bar_called_in = "TestServiceA"

