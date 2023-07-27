extends Node

## Allows the use of a class name to used to register and retrieve implementations of
## services.


var _services := {}
var _named_services := {}


## Registers a service implementation.  Optionally a name can be given as an extra key.  This extra key (name)
## is used later in [method get_service] to retreive that specific implementation.
## [br]
## e.g. of registering an implementation.
## [codeblock]
##  class_name Foo
##  extends Node
##  func _enter_tree():
##    ServiceMgr.register_service(Foo, self)
## [/codeblock]
func register_service(service: Script, implementation: Object, service_name: String = "") -> void:
	if service_name != "":
		if !_named_services.has(service):
			_named_services[service] = {}
		_named_services[service][service_name] = implementation
	else:
		_services[service] = implementation
	if implementation is Node:
		_watch_service_implementation_tree_exit(service, implementation, service_name)


## Gets a service implementation.  Optionally a name can be given as an extra key to find a specific implementation.
## [br]
## e.g. of getting a service
## [codeblock]
##  class_name Bar
##  extends Node
##  func _do_important_thing_with_service():
##    var foo_svc:Foo = ServiceMgr.get_service(Foo)
##    if foo_svc == null:
##      print_err("Could not do important thing: no Foo service registered")
##      return
##    foo_svc.do_the_thing()
## [/codeblock]
## [br]
func get_service(service: Script, service_name: String = "") -> Object:
	if service_name != "":
		if _named_services.has(service):
			if _named_services[service].has(service_name):
				return _named_services[service][service_name]

	if _services.has(service):
		return _services[service]
	return null

## Unregisters a service implementation.
func unregister_service(service: Script, service_name: String = "") -> void:
	if service_name != "":
		if _named_services.has(service):
			if _named_services[service].has(service_name):
				var implementation:Object = _named_services[service][service_name]
				if implementation is Node:
					implementation.disconnect("tree_exited",Callable(self,"_on_implementation_tree_exited"))
			_named_services[service].erase(service_name)
		return
	if _services.has(service):
		var implementation: Object = _services[service]
		if implementation is Node:
			implementation.disconnect("tree_exited",Callable(self,"_on_implementation_tree_exited"))
	_services.erase(service)


func _watch_service_implementation_tree_exit(service: Script, implementation: Object, service_name: String = "") -> void:
	implementation.connect("tree_exited",Callable(self,"_on_implementation_tree_exited").bind(service, service_name))


func _on_implementation_tree_exited(service: Script, service_name: String) -> void:
	unregister_service(service, service_name)
