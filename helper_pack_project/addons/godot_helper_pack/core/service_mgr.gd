extends Node

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
					implementation.disconnect("tree_exited",Callable(self,"_on_implementation_tree_exited"))
			_named_services[service].erase(name)
		return
	if _services.has(service):
		var implementation: Object = _services[service]
		if implementation is Node:
			implementation.disconnect("tree_exited",Callable(self,"_on_implementation_tree_exited"))
	_services.erase(service)


func _watch_service_implementation_tree_exit(service: Script, implementation: Object, name: String = "") -> void:
	implementation.connect("tree_exited",Callable(self,"_on_implementation_tree_exited").bind(service, name))


func _on_implementation_tree_exited(service: Script, name: String) -> void:
	unregister_service(service, name)
