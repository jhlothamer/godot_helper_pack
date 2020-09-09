extends "res://addons/gut/test.gd"


func test_append_all_source_elements_in_destination():
	var source_array := [1, "two", {"three": "four"}]
	var destination_array := []
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size(), destination_array.size())
	for i in range(destination_array.size()):
		assert_eq(source_array[i], destination_array[i])


func test_append_all_source_elements_in_destination_with_non_empty_destination():
	var source_array := [1, "two", {"three": "four"}]
	var destination_array := ["already here"]
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size() + 1, destination_array.size())
	for i in range(source_array.size()):
		assert_eq(source_array[i], destination_array[i + 1])


func test_append_all_source_elements_in_destination_with_empty_arrays():
	var source_array := []
	var destination_array := []
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size(), destination_array.size())


func test_append_all_source_elements_in_destination_with_empty_source():
	var source_array := []
	var destination_array := ["already here"]
	ArrayUtil.append_all(destination_array, source_array)
	assert_eq(source_array.size() + 1, destination_array.size())


func test_get_rand_returns_item_from_array():
	var source_array := [1, "two", {"three": "four"}]
	var result = ArrayUtil.get_rand(source_array)
	assert_true(source_array.has(result))


func test_get_rand_handles_empty_array():
	var source_array := []
	var result = ArrayUtil.get_rand(source_array)
	assert_null(result)


func test_has_any_detects_single_common_item():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := [10,11,12,13,14,15]
	array_b.append(ArrayUtil.get_rand(array_a))
	var result = ArrayUtil.has_any(array_a, array_b)
	assert_true(result)


func test_has_any_detects_no_common_item():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := [10,11,12,13,14,15]
	var result = ArrayUtil.has_any(array_a, array_b)
	assert_false(result)


func test_has_any_handles_different_types():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := ["10","11","12","13","14","15"]
	array_b.append(ArrayUtil.get_rand(array_a))
	var result = ArrayUtil.has_any(array_a, array_b)
	assert_true(result)


func test_has_all_handles_single_common_item():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := [10,11,12,13,14,15]
	array_b.append(ArrayUtil.get_rand(array_a))
	var result = ArrayUtil.has_all(array_a, array_b)
	assert_false(result)


func test_has_all_detects_no_common_item():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := [10,11,12,13,14,15]
	var result = ArrayUtil.has_all(array_a, array_b)
	assert_false(result)


func test_has_all_handles_different_types():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := ["10","11","12","13","14","15"]
	array_b.append(ArrayUtil.get_rand(array_a))
	var result = ArrayUtil.has_all(array_a, array_b)
	assert_false(result)


func test_has_all_detects_all_common_item():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := [1,2,3,4,5,6,7,8,9]
	var result = ArrayUtil.has_all(array_a, array_b)
	assert_true(result)


func test_has_all_detects_one_mismatched_item():
	var array_a := [1,2,3,4,5,6,7,8,9]
	var array_b := [1,2,3,4,5,6,7,8,9,10]
	var result = ArrayUtil.has_all(array_a, array_b)
	assert_false(result)
