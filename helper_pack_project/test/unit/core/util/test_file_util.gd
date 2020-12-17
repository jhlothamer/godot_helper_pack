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

