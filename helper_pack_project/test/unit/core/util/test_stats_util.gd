extends "res://addons/gut/test.gd"


func test_linear_regression_known_good_data_and_results():
	#data from http://www.intellspot.com/linear-regression-examples/
	var x_array = [1.7,1.5,2.8,5,1.3,2.2,1.3]
	var y_array = [368,340,665,954,331,556,376]
	var line:StatsUtil.Line = StatsUtil.linear_regression(x_array, y_array)
	assert_not_null(line)
	assert_almost_eq(line.b, 125.8, .05)
	assert_almost_eq(line.m, 171.5, .05)
	
	
