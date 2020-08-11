extends Node
"""
Signal Manager automatically connects subscribers to the signals of publishers.
"""


class Subscriber:
	var subscriber: Object
	var signalName: String
	var method: String
	var binds
	func _init(subscriber_: Object, signalName_: String, method_: String, binds_:Array) -> void:
		subscriber = subscriber_
		signalName = signalName_
		method = method_
		binds = binds_
	func connect_publisher(publisher: Object) -> void:
		if !publisher.is_connected(signalName, subscriber, method):
			publisher.connect(signalName, subscriber, method, binds)

class Publisher:
	var publisher: Object
	var signalName: String
	func _init(publisher_: Object, signalName_: String) -> void:
		publisher = publisher_
		signalName = signalName_
	func connect_subscribers(subscribers: Subscriber) -> void:
		for subscriber in subscribers:
			subscriber.connect_publisher(publisher)
	func connect_subscriber(subscriber: Subscriber) -> void:
		subscriber.connect_publisher(publisher)


var subscriber_method_prefix := "_on_"

var _subscribers = {}
var _publishers = {}


func register_subscriber(subscriber: Object, signalName: String, method: String="", binds:Array =Array()) -> void:
	if method == "":
		method = subscriber_method_prefix + signalName
	var sub = Subscriber.new(subscriber, signalName, method, binds)
	var instance_id = subscriber.get_instance_id()
	if !_subscribers.has(instance_id):
		_subscribers[instance_id] = []
		_watch_tree_exited(subscriber)
	_subscribers[instance_id].append(sub)
	for pubs in _publishers.values():
		for pub in pubs:
			if pub.signalName == sub.signalName:
				pub.connect_subscriber(sub)


func register_publisher(publisher: Object, signalName: String) -> void:
	var pub = Publisher.new(publisher, signalName)
	var instance_id = publisher.get_instance_id()
	if !_publishers.has(instance_id):
		_publishers[instance_id] = []
		_watch_tree_exited(publisher)
	_publishers[instance_id].append(pub)
	for subs in _subscribers.values():
		for sub in subs:
			if sub.signalName == pub.signalName:
				pub.connect_subscriber(sub)


func unregister_subscriber(subscriber: Object) -> void:
	var instance_id = subscriber.get_instance_id()
	_subscribers.erase(instance_id)


func unregister_publisher(publisher: Object) -> void:
	var instance_id = publisher.get_instance_id()
	_publishers.erase(instance_id)


func unregister(publisherOrSubscriber: Object) -> void:
	unregister_publisher(publisherOrSubscriber)
	unregister_subscriber(publisherOrSubscriber)


func clear() -> void:
	_subscribers.clear()
	_publishers.clear()


func _watch_tree_exited(publisherSubscriber: Object) -> void:
	if !publisherSubscriber.is_connected("tree_exited", self, "_on_tree_exited"):
		publisherSubscriber.connect("tree_exited", self, "_on_tree_exited", [publisherSubscriber])


func _on_tree_exited(publisherSubscriber: Object) -> void:
	unregister(publisherSubscriber)
