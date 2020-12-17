extends "res://addons/gut/test.gd"

enum LoremEnum {
	IPSUM,
	DOLOR,
	SIT,
	AMET
}

func test_get_array_returns_array_of_ids():
	var array = EnumUtil.get_array(LoremEnum)
	assert_eq(array, [0,1,2,3])

func test_get_array_returns_array_of_strings():
	var array = EnumUtil.get_names_string_array(LoremEnum)
	assert_eq(array, ["IPSUM", "DOLOR", "SIT", "AMET"])

func test_get_string_returns_correct_string():
	var results = EnumUtil.get_string(LoremEnum, LoremEnum.SIT)
	assert_eq(results, "SIT")

func test_get_id_returns_correct_id():
	var results = EnumUtil.get_id(LoremEnum, "AMET")
	assert_eq(results, LoremEnum.AMET)
