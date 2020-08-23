extends "res://addons/gut/test.gd"

func test_stop_watch():
	var stop_watch = StopWatch.new()
	stop_watch.start()
	yield(get_tree().create_timer(.01), "timeout")
	stop_watch.stop()
	var msec = stop_watch.get_elapsed_msec()
	var usec = stop_watch.get_elapsed_usec()
	assert_true(msec > 0.0)
	assert_true(usec > 0.0)
	assert_true(stop_watch._stop_time > stop_watch._start_time)
	assert_eq(msec * 1000, usec)
