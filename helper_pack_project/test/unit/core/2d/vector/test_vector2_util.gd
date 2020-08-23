extends "res://addons/gut/test.gd"

func test_equal():
	var v1 = Vector2(-0, -0)
	var v2 = Vector2(0, 0)
	var results = Vector2Util.equal(v1, v2)
	assert_true(results)

func test_not_equal():
	var v1 = Vector2(-0, -0)
	var v2 = Vector2(1, 1)
	var results = Vector2Util.equal(v1, v2)
	assert_false(results)


func test_vectors_left_vs_up():
	var results = Vector2Util.closest_angle_to(Vector2.LEFT, Vector2.UP)
	var rotated = Vector2.LEFT.rotated(results)
	assert_true(Vector2Util.equal(Vector2.UP, rotated))


func test_vectors_left_vs_down():
	var results = Vector2Util.closest_angle_to(Vector2.LEFT, Vector2.DOWN)
	var rotated = Vector2.LEFT.rotated(results)
	assert_true(Vector2Util.equal(Vector2.DOWN, rotated))


func test_vectors_up_vs_left():
	var results = Vector2Util.closest_angle_to(Vector2.UP, Vector2.LEFT)
	var rotated = Vector2.UP.rotated(results)
	assert_true(Vector2Util.equal(Vector2.LEFT, rotated))


func test_vectors_down_vs_left():
	var results = Vector2Util.closest_angle_to(Vector2.DOWN, Vector2.LEFT)
	var rotated = Vector2.DOWN.rotated(results)
	assert_true(Vector2Util.equal(Vector2.LEFT, rotated))
