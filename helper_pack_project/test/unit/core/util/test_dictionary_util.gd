extends "res://addons/gut/test.gd"


func test_all_unique_elements_added_to_dictionary():
	var keys_array := ["0", "1", "1", "2"]
	var dictionary := {}
	DictionaryUtil.add_keys(dictionary, keys_array)
	assert_eq(3, dictionary.size())
	for key in keys_array:
		assert_true(dictionary.has(key))
		assert_null(dictionary[key])

func test_value_passed_in_is_value_for_dictionary_values():
	var keys_array := [Vector2.ZERO, Vector2.UP, Vector2.DOWN, Vector2.LEFT]
	var dictionary := {}
	DictionaryUtil.add_keys(dictionary, keys_array, "value")
	assert_eq(keys_array.size(), dictionary.size())
	for key in keys_array:
		assert_true(dictionary.has(key))
		assert_eq("value", dictionary[key])
