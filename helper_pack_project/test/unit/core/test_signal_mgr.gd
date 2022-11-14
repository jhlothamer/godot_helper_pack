extends "res://addons/gut/test.gd"


class TestPublisher:
	#warning-ignore:unused_signal
	signal foo()
	#warning-ignore:unused_signal
	signal tree_exited()


class TestSubscriber:
	#warning-ignore:unused_signal
	signal tree_exited()
	func bar():
		pass


func test_mgr_connects_publisher_to_subscriber():
	var publisher = TestPublisher.new()
	SignalMgr.register_publisher(publisher, "foo")
	var subscriber = TestSubscriber.new()
	SignalMgr.register_subscriber(subscriber, "foo", "bar")
	assert_true(publisher.is_connected("foo",Callable(subscriber,"bar")))
