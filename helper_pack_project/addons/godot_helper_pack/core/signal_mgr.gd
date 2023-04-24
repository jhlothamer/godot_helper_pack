extends Node
## Automatically connects subscribers to the signals of publishers.
##
## The SignalMgr autoload singleton lets you register publishers and subscribers
## of signals.  This way you don't have to pass around a reference to an object
## in order to connnect a callback function for a signal.  This is also handy for
## dynamically instanced signal emitters, like enemies, which can register themselves,
## emit their signals as normal, and then be freed.

class Subscriber:
	var subscriber: Object
	var signal_name: String
	var method_name: String
	var binds: Array
	func _init(_subscriber: Object,_signal_name: String,_method_name: String,_binds:Array):
		subscriber = _subscriber
		signal_name = _signal_name
		method_name = _method_name
		binds = _binds
	func connect_publisher(publisher: Object) -> void:
		if !publisher.is_connected(signal_name,Callable(subscriber,method_name)):
			if binds != null and !binds.is_empty():
				publisher.connect(signal_name,Callable(subscriber,method_name).bind(binds))
			else:
				publisher.connect(signal_name,Callable(subscriber,method_name))

class Publisher:
	var publisher: Object
	var signal_name: String
	func _init(_publisher: Object,_signal_name: String):
		publisher = _publisher
		signal_name = _signal_name
	func connect_subscribers(subscribers: Array) -> void:
		for subscriber in subscribers:
			subscriber.connect_publisher(publisher)
	func connect_subscriber(subscriber: Subscriber) -> void:
		subscriber.connect_publisher(publisher)

# If a subscriber callback method name is not supplied when a subscriber is registered
# for a signal, then the callback method name will be assumed to be this string prefixed
# to the signal name.  E.g. "_on_enemy_destroyed" for a signal with the name "enemy_destroyed".
const subscriber_method_name_prefix := "_on_"

# dictionary of subscribers
var _subscribers:Dictionary = {}
# dictionary of publishers
var _publishers:Dictionary = {}

## register a subscriber for a signal.  The default method name for the callback function
## is "_on_<signal>".
func register_subscriber(subscriber: Object, signal_name: String,
	method_name: String="", binds:Array =Array()) -> void:
	if method_name == "":
		method_name = subscriber_method_name_prefix + signal_name
	var sub = Subscriber.new(subscriber, signal_name, method_name, binds)
	var instance_id = subscriber.get_instance_id()
	if !_subscribers.has(instance_id):
		_subscribers[instance_id] = []
		_watch_tree_exited(subscriber)
	_subscribers[instance_id].append(sub)
	for pubs in _publishers.values():
		for pub in pubs:
			if pub.signal_name == sub.signal_name:
				pub.connect_subscriber(sub)

## register a publisher of a signal.
func register_publisher(publisher: Object, signal_name: String) -> void:
	var pub = Publisher.new(publisher, signal_name)
	var instance_id = publisher.get_instance_id()
	if !_publishers.has(instance_id):
		_publishers[instance_id] = []
		_watch_tree_exited(publisher)
	_publishers[instance_id].append(pub)
	for subs in _subscribers.values():
		for sub in subs:
			if sub.signal_name == pub.signal_name:
				pub.connect_subscriber(sub)


## unregister a subscriber.
func unregister_subscriber(subscriber: Object) -> void:
	var instance_id = subscriber.get_instance_id()
	_subscribers.erase(instance_id)


## unregister a publisher.
func unregister_publisher(publisher: Object) -> void:
	var instance_id = publisher.get_instance_id()
	_publishers.erase(instance_id)


## unregister a publisher or subscriber (or both)
func unregister(publisher_or_subscriber: Object) -> void:
	unregister_publisher(publisher_or_subscriber)
	unregister_subscriber(publisher_or_subscriber)


## clears all subscribers and publishers
func clear() -> void:
	_subscribers.clear()
	_publishers.clear()


func _watch_tree_exited(publisher_or_subscriber: Object) -> void:
	if !publisher_or_subscriber.has_signal("tree_exited"):
		return
	if !publisher_or_subscriber.is_connected("tree_exited",Callable(self,"_on_tree_exited")):
		publisher_or_subscriber.connect("tree_exited",Callable(self,"_on_tree_exited").bind(publisher_or_subscriber))


func _on_tree_exited(publisher_or_subscriber: Object) -> void:
	unregister(publisher_or_subscriber)
