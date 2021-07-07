extends Node
"""
Singleton class serving as a service instance repository.  This class is 
meant to be registered as an autoload singleton.

To use this manager create an empty service class and then extend this class
in an implementation class (class that actually implements the service.)

e.g.

# Interface class:
class_name FooSvc
Extends SomeGodotType

func bar():
	pass

# Implementation class:
Extends FooSvc

func _enter_tree():
	ServiceMgr.register_service(FooSvc, self)

func bar():
	# real implementation of function

# Alternatively interface class and implementation class in same script filename
class_name FooSvc
Extends SomeGodotType

func _enter_tree():
	ServiceMgr.register_service(self.get_script(), self)

func bar():
	# real implementation of function


Then use the type to get a reference to the service.  Note how the variable
is typed too.  That will help with intellisense (though not show properties as
of Godot 3.2.3).

var foo_svc:FooSvc = ServiceMgr.get_service(FooSvc)
if !foo_svc:
	# gracefully degrade functionality or/and complain
	return
# call service
foo_svc.bar()
"""

var _services := {}
var _named_services := {}


func register_service(service: Script, implementation: Object, name: String = "") -> void:
	if name != "":
		if !_named_services.has(service):
			_named_services[service] = {}
		_named_services[service][name] = implementation
	else:
		_services[service] = implementation
	if implementation is Node:
		_watch_service_implementation_tree_exit(service, implementation, name)


func get_service(service: Script, name: String = "") -> Object:
	if name != "":
		if _named_services.has(service):
			if _named_services[service].has(name):
				return _named_services[service][name]

	if _services.has(service):
		return _services[service]
	return null


func unregister_service(service: Script, name: String = "") -> void:
	if name != "":
		if _named_services.has(service):
			if _named_services[service].has(name):
				var implementation:Object = _named_services[service][name]
				if implementation is Node:
					implementation.disconnect("tree_exited", self, "_on_implementation_tree_exited")
			_named_services[service].erase(name)
		return
	if _services.has(service):
		var implementation: Object = _services[service]
		if implementation is Node:
			implementation.disconnect("tree_exited", self, "_on_implementation_tree_exited")
	_services.erase(service)


func _watch_service_implementation_tree_exit(service: Script, implementation: Object, name: String = "") -> void:
	implementation.connect("tree_exited", self, "_on_implementation_tree_exited", [service, name])


func _on_implementation_tree_exited(service: Script, name: String) -> void:
	unregister_service(service, name)
