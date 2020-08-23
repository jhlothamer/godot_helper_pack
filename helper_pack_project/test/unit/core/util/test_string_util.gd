extends "res://addons/gut/test.gd"

func test_non_empty_string_is_not_null_or_empty():
	var results = StringUtil.is_null_or_empty("not empty")
	assert_false(results)


func test_empty_string_is_null_or_empty():
	var results = StringUtil.is_null_or_empty("")
	assert_true(results)

func test_null_string_is_null_or_empty():
	var s : String
	var results = StringUtil.is_null_or_empty(s)
	assert_true(results)

func test_get_file_name_with_actual_file_path():
	var file_path := "res://file.txt"
	var file_name = StringUtil.get_file_name(file_path)
	assert_eq("file", file_name)

func test_get_file_name_with_empty_file_path():
	var file_path := ""
	var file_name = StringUtil.get_file_name(file_path)
	assert_eq("", file_name)

func test_get_file_name_with_null_file_path():
	var file_path : String
	var file_name = StringUtil.get_file_name(file_path)
	assert_eq("", file_name)

func test_get_file_name_from_path_with_no_extension():
	var file_path := "file_with_no_extension"
	var file_name = StringUtil.get_file_name(file_path)
	assert_eq(file_path, file_name)
