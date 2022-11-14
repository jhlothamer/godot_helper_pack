extends "res://addons/gut/test.gd"

var _test_service_a_impl1_class = preload("res://test/services/test_service_a_impl1.gd")
var _test_service_a_impl2_class = preload("res://test/services/test_service_a_impl2.gd")


func after_each():
	for service in ServiceMgr._services.keys():
		ServiceMgr.unregister_service(service)
	if ServiceMgr._services.size() > 0:
		printerr("TestServiceMgr: non-named services left registered.")
	for service in ServiceMgr._named_services.keys():
		var named_services:Dictionary = ServiceMgr._named_services[service]
		for name in named_services.keys():
			ServiceMgr.unregister_service(service, name)
	if ServiceMgr._named_services.size() > 0:
		for services in ServiceMgr._named_services.values():
			if services.size() > 0:
				printerr("TestServiceMgr: named services left registered.")


func test_register_succeeds():
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl1_class.new())
	var test_service = ServiceMgr.get_service(TestServiceA)
	assert_not_null(test_service)
	test_service.foo()
	assert_eq(test_service._test_service_a_foo_called_in, "TestServiceAImpl1")
	var results = test_service.is_connected("tree_exited",Callable(ServiceMgr,"_on_implementation_tree_exited"))
	assert_true(results)


func test_register_named_instance_succeeds():
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl1_class.new(), "Impl1")
	var test_service = ServiceMgr.get_service(TestServiceA, "Impl1")
	assert_not_null(test_service)
	test_service.foo()
	assert_eq(test_service._test_service_a_foo_called_in, "TestServiceAImpl1")
	var results = test_service.is_connected("tree_exited",Callable(ServiceMgr,"_on_implementation_tree_exited"))
	assert_true(results)


func test_register_multi_named_instance_succeeds():
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl1_class.new(), "Impl1")
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl2_class.new(), "Impl2")
	var test_service1 = ServiceMgr.get_service(TestServiceA, "Impl1")
	var test_service2 = ServiceMgr.get_service(TestServiceA, "Impl2")
	assert_not_null(test_service1)
	assert_not_null(test_service2)
	assert_ne(test_service1, test_service2)
	var results = test_service1.is_connected("tree_exited",Callable(ServiceMgr,"_on_implementation_tree_exited"))
	assert_true(results)
	results = test_service2.is_connected("tree_exited",Callable(ServiceMgr,"_on_implementation_tree_exited"))
	assert_true(results)


class Foo:
	func foo():
		pass


class Bar:
	func foo():
		pass


func test_register_non_node_succeeds():
	ServiceMgr.register_service(Foo, Foo.new())
	var test_service = ServiceMgr.get_service(Foo)
	assert_not_null(test_service)
	test_service.foo()


func test_register_multi_named_non_node_instance_succeeds():
	ServiceMgr.register_service(Foo, Foo.new(), "Impl1")
	ServiceMgr.register_service(Bar, Bar.new(), "Impl2")
	var test_service1 = ServiceMgr.get_service(Foo, "Impl1")
	var test_service2 = ServiceMgr.get_service(Bar, "Impl2")
	assert_not_null(test_service1)
	assert_not_null(test_service2)
	assert_ne(test_service1, test_service2)
