extends "res://addons/gut/test.gd"


func test_load_text_with_non_existent_file():
	var results = FileUtil.load_text("res://non_existent.txt")
	assert_eq(results, "")


func test_load_text_returns_correct_string():
	var results = FileUtil.load_text("res://test/files/test.txt")
	var expected = "Lorem ipsum dolor sit amet"
	results = results.left(expected.length())
	assert_eq(results, expected)


func test_load_json_data_with_non_existent_file():
	var results = FileUtil.load_json_data("res://non_existent.json")
	assert_not_null(results)
	assert_eq(results.size(), 0)


func test_load_json_data_returns_correct_data():
	var results = FileUtil.load_json_data("res://test/files/test.json")
	assert_not_null(results)
	assert_eq(results.size(), 1)
	assert_true(results.has("Lorem"))
	assert_eq(results["Lorem"], "ipsum")


func test_save_load_var_data_vector2():
	var data = {
		"sub_dictionary": {
			"vector2": Vector2.ONE
		}
	}
	var save_load_test_file = "res://test/files/test_var_data_vector2.json"
	FileUtil.save_var_data(save_load_test_file, data)
	var results = FileUtil.load_var_data(save_load_test_file)
	assert_true(results is Dictionary)
	assert_true(results.has("sub_dictionary"))
	assert_true(results["sub_dictionary"] is Dictionary)
	assert_true(results["sub_dictionary"].has("vector2"))
	assert_true(results["sub_dictionary"]["vector2"] is Vector2)


