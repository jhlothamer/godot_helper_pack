extends "res://addons/gut/test.gd"


func test_source_elements_in_destination():
	var source_array := [1, "two", {"three": "four"}]
	var destination_array := []
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size(), destination_array.size())
	for i in range(destination_array.size()):
		assert_eq(source_array[i], destination_array[i])


func test_source_elements_in_destination_with_non_empty_destination():
	var source_array := [1, "two", {"three": "four"}]
	var destination_array := ["already here"]
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size() + 1, destination_array.size())
	for i in range(source_array.size()):
		assert_eq(source_array[i], destination_array[i + 1])


func test_source_elements_in_destination_with_empty_arrays():
	var source_array := []
	var destination_array := []
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size(), destination_array.size())


func test_source_elements_in_destination_with_empty_source():
	var source_array := []
	var destination_array := ["already here"]
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size() + 1, destination_array.size())
