extends "res://addons/gut/test.gd"

var _test_service_a_impl1_class = preload("res://test/services/test_service_a_impl1.gd")
var _test_service_a_impl2_class = preload("res://test/services/test_service_a_impl2.gd")


func after_each():
	for service in ServiceMgr._services.keys():
		ServiceMgr.unregister_service(service, ServiceMgr._services[service])
	for service in ServiceMgr._named_services.keys():
		var named_services:Dictionary = ServiceMgr._named_services[service]
		for name in named_services.keys():
			ServiceMgr.unregister_service(service, named_services[name], name)


func test_register_succeeds():
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl1_class.new())
	var test_service = ServiceMgr.get_service(TestServiceA)
	assert_not_null(test_service)
	test_service.foo()
	assert_eq(test_service._test_service_a_foo_called_in, "TestServiceAImpl1")


func test_register_named_instance_succeeds():
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl1_class.new(), "Impl1")
	var test_service = ServiceMgr.get_service(TestServiceA, "Impl1")
	assert_not_null(test_service)
	test_service.foo()
	assert_eq(test_service._test_service_a_foo_called_in, "TestServiceAImpl1")


func test_register_multi_named_instance_succeeds():
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl1_class.new(), "Impl1")
	ServiceMgr.register_service(TestServiceA, _test_service_a_impl2_class.new(), "Impl2")
	var test_service1 = ServiceMgr.get_service(TestServiceA, "Impl1")
	var test_service2 = ServiceMgr.get_service(TestServiceA, "Impl2")
	assert_not_null(test_service1)
	assert_not_null(test_service2)
	assert_ne(test_service1, test_service2)
