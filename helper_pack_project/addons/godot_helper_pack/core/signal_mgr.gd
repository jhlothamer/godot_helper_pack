extends Node
"""
Signal Manager automatically connects subscribers to the signals of publishers.
"""


class Subscriber:
	var subscriber: Object
	var signal_name: String
	var method_name: String
	var binds
	func _init(_subscriber: Object, _signal_name: String, _method_name: String, _binds:Array) -> void:
		subscriber = _subscriber
		signal_name = _signal_name
		method_name = _method_name
		binds = _binds
	func connect_publisher(publisher: Object) -> void:
		if !publisher.is_connected(signal_name, subscriber, method_name):
			publisher.connect(signal_name, subscriber, method_name, binds)

class Publisher:
	var publisher: Object
	var signal_name: String
	func _init(_publisher: Object, _signal_name: String) -> void:
		publisher = _publisher
		signal_name = _signal_name
	func connect_subscribers(subscribers: Subscriber) -> void:
		for subscriber in subscribers:
			subscriber.connect_publisher(publisher)
	func connect_subscriber(subscriber: Subscriber) -> void:
		subscriber.connect_publisher(publisher)


var subscriber_method_name_prefix := "_on_"

var _subscribers = {}
var _publishers = {}


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


func unregister_subscriber(subscriber: Object) -> void:
	var instance_id = subscriber.get_instance_id()
	_subscribers.erase(instance_id)


func unregister_publisher(publisher: Object) -> void:
	var instance_id = publisher.get_instance_id()
	_publishers.erase(instance_id)


func unregister(publisher_or_subscriber: Object) -> void:
	unregister_publisher(publisher_or_subscriber)
	unregister_subscriber(publisher_or_subscriber)


func clear() -> void:
	_subscribers.clear()
	_publishers.clear()


func _watch_tree_exited(publisher_or_subscriber: Object) -> void:
	if !publisher_or_subscriber.is_connected("tree_exited", self, "_on_tree_exited"):
		publisher_or_subscriber.connect("tree_exited", self, "_on_tree_exited", [publisher_or_subscriber])


func _on_tree_exited(publisher_or_subscriber: Object) -> void:
	unregister(publisher_or_subscriber)
