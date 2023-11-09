extends "res://addons/gut/test.gd"

func test_between_zero_in_plus_minus_pi():
	var results = AngleUtil.between(0.0, -PI, PI)
	assert_true(results)


func test_between_pi_in_plus_minus_pi():
	var results = AngleUtil.between(PI, -PI, PI)
	assert_true(results)


func test_between_minus_pi_in_plus_minus_pi():
	var results = AngleUtil.between(-PI, -PI, PI)
	assert_true(results)


func test_between_minus_half_pi_in_top_half():
	var results = AngleUtil.between(-.5*PI, -PI, 0)
	assert_true(results)


func test_between_half_pi_not_in_top_half():
	var results = AngleUtil.between(.5*PI, -PI, 0)
	assert_false(results)


func test_between_zero_in_right_half():
	var results = AngleUtil.between(0, -.5*PI, .5*PI)
	assert_true(results)


func test_between_pi_not_in_right_half():
	var results = AngleUtil.between(PI, -.5*PI, .5*PI)
	assert_false(results)


func test_between_minus_pi_not_in_right_half():
	var results = AngleUtil.between(-PI, -.5*PI, .5*PI)
	assert_false(results)


func test_between_half_pi_in_bottom_half():
	var results = AngleUtil.between(.5*PI, 0, PI)
	assert_true(results)


func test_between_minus_half_pi_not_in_bottom_half():
	var results = AngleUtil.between(-.5*PI, 0, PI)
	assert_false(results)


func test_between_pi_in_left_half():
	var results = AngleUtil.between(PI, .5*PI, -.5*PI)
	assert_true(results)


func test_between_zero_not_in_left_half():
	var results = AngleUtil.between(0, .5*PI, -.5*PI)
	assert_false(results)


func test_between_quadrant_1():
	var start_angle = -.5*PI
	var end_angle = 0.0
	var results = AngleUtil.between(-.25*PI, start_angle, end_angle)
	assert_true(results)


func test_between_not_in_quadrant_1():
	var start_angle = -.5*PI
	var end_angle = 0.0
	var results = AngleUtil.between(-.75*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(.25*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(.75*PI, start_angle, end_angle)
	assert_false(results)


func test_between_in_quadrant_2():
	var start_angle = -PI
	var end_angle = -.5*PI
	var results = AngleUtil.between(-.75*PI, start_angle, end_angle)
	assert_true(results)


func test_between_not_in_quadrant_2():
	var start_angle = -PI
	var end_angle = -.5*PI
	var results = AngleUtil.between(-.25*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(.25*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(.75*PI, start_angle, end_angle)
	assert_false(results)


func test_between_in_quadrant_3():
	var start_angle = .5*PI
	var end_angle = PI
	var results = AngleUtil.between(.75*PI, start_angle, end_angle)
	assert_true(results)


func test_between_not_in_quadrant_3():
	var start_angle = .5*PI
	var end_angle = PI
	var results = AngleUtil.between(-.25*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(.25*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(-.75*PI, start_angle, end_angle)
	assert_false(results)


func test_between_in_quadrant_4():
	var start_angle = 0.0
	var end_angle = .5*PI
	var results = AngleUtil.between(.25*PI, start_angle, end_angle)
	assert_true(results)


func test_between_in_not_quadrant_4():
	var start_angle = 0.0
	var end_angle = .5*PI
	var results = AngleUtil.between(-.25*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(.75*PI, start_angle, end_angle)
	assert_false(results)
	results = AngleUtil.between(-.75*PI, start_angle, end_angle)
	assert_false(results)


func test_clamp_angle_top_half_angle_in():
	var start_angle := -PI
	var end_angle := 0.0
	var test_angle := -.5*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_top_half_angle_close_to_end():
	var start_angle := -PI
	var end_angle := 0.0
	var test_angle := .25*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_top_half_angle_close_to_start():
	var start_angle := -PI
	var end_angle := 0.0
	var test_angle := .75*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_clamp_angle_right_half_angle_in():
	var start_angle := -.5*PI
	var end_angle := .5*PI
	var test_angle := 0.0
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_right_half_angle_close_to_end():
	var start_angle := -.5*PI
	var end_angle := .5*PI
	var test_angle := .75*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_right_half_angle_close_to_start():
	var start_angle := -.5*PI
	var end_angle := .5*PI
	var test_angle := -.75*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)



func test_clamp_angle_bottom_half_angle_in():
	var start_angle := 0.0
	var end_angle :=  PI
	var test_angle := .5*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_bottom_half_angle_close_to_end():
	var start_angle := 0.0
	var end_angle :=  PI
	var test_angle := -.75*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_bottom_half_angle_close_to_start():
	var start_angle := 0.0
	var end_angle :=  PI
	var test_angle := -.25*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)
	
	

func test_clamp_angle_left_half_angle_in():
	var start_angle := .5*PI
	var end_angle := -.5*PI
	var test_angle := PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_left_half_angle_close_to_end():
	var start_angle := .5*PI
	var end_angle := -.5*PI
	var test_angle := -.25*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_left_half_angle_close_to_start():
	var start_angle := .5*PI
	var end_angle := -.5*PI
	var test_angle := .25*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_clamp_angle_top_wedge_in():
	var start_angle := -.75*PI
	var end_angle := -.25*PI
	var test_angle := -.5*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_top_wedge_close_to_end():
	var start_angle := -.75*PI
	var end_angle := -.25*PI
	var test_angle := .25*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_top_wedge_close_to_start():
	var start_angle := -.75*PI
	var end_angle := -.25*PI
	var test_angle := .75*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_clamp_angle_right_wedge_in():
	var start_angle := -.25*PI
	var end_angle := .25*PI
	var test_angle := 0.0
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_right_wedge_close_to_end():
	var start_angle := -.25*PI
	var end_angle := .25*PI
	var test_angle := .75*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_right_wedge_close_to_start():
	var start_angle := -.25*PI
	var end_angle := .25*PI
	var test_angle := -.75*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_clamp_angle_bottom_wedge_in():
	var start_angle := .25*PI
	var end_angle := .75*PI
	var test_angle := .5*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_bottom_wedge_close_to_end():
	var start_angle := .25*PI
	var end_angle := .75*PI
	var test_angle := PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_bottom_wedge_close_to_start():
	var start_angle := .25*PI
	var end_angle := .75*PI
	var test_angle := 0.0
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_clamp_angle_left_wedge_in():
	var start_angle := .75*PI
	var end_angle := -.75*PI
	var test_angle := PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_clamp_angle_left_wedge_close_to_end():
	var start_angle := .75*PI
	var end_angle := -.75*PI
	var test_angle := -.25*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_clamp_angle_left_wedge_close_to_start():
	var start_angle := .75*PI
	var end_angle := -.75*PI
	var test_angle := .25 * PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_clamp_angle_plus_minus_pie_in():
	var start_angle := -PI
	var end_angle := PI
	var test_angle := 0.0
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)
	test_angle = PI
	results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)
	test_angle = -PI
	results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)
	test_angle = randi() * PI
	results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)

func test_90_deg_about_right_out_close_to_start():
	var start_angle := -.25*PI
	var end_angle := .25*PI
	var test_angle := -.5*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_90_deg_about_right_out_very_close_to_start():
	var start_angle := -.25*PI
	var end_angle := .25*PI
	var test_angle := -.25*PI - .00001
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)
	assert_true(results == start_angle)


func test_90_deg_about_right_out_close_to_end():
	var start_angle := -.25*PI
	var end_angle := .25*PI
	var test_angle := .5*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_90_deg_about_right_in():
	var start_angle := -.25*PI
	var end_angle := .25*PI
	var test_angle := 0
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)

########################

func test_90_deg_about_down_out_close_to_start():
	var start_angle := .25*PI
	var end_angle := .75*PI
	var test_angle := .15*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)


func test_90_deg_about_down_out_very_close_to_start():
	var start_angle := .25*PI
	var end_angle := .75*PI
	var test_angle := .25*PI - .00001
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)
	assert_true(results == start_angle)


func test_90_deg_about_down_out_close_to_end():
	var start_angle := .25*PI
	var end_angle := .75*PI
	var test_angle := .85*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, end_angle)


func test_90_deg_about_down_in():
	var start_angle := .25*PI
	var end_angle := .75*PI
	var test_angle := .5*PI
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, test_angle)


func test_foo_foo():
	var start_angle := deg_to_rad(44.998936)
	var end_angle := deg_to_rad(134.998935)
	var test_angle := deg_to_rad(44.998932)
	var results = AngleUtil.clamp_angle(test_angle, start_angle, end_angle)
	assert_eq(results, start_angle)
	



