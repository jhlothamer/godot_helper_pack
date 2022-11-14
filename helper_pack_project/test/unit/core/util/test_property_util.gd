extends "res://addons/gut/test.gd"

var _property_1 := 1
var _property_2


func test_object_has_property_no_type():
	var results = PropertyUtil.has_property(self, "_property_1")
	assert_true(results)


func test_object_has_property_with_type():
	var results = PropertyUtil.has_property(self, "_property_1", TYPE_INT)
	assert_true(results)


func test_object_does_not_have_property_no_type():
	var results = PropertyUtil.has_property(self, "_property_x")
	assert_false(results)


func test_object_does_not_have_property_with_type():
	var results = PropertyUtil.has_property(self, "_property_1", TYPE_BOOL)
	assert_false(results)


func test_object_does_has_variant_property_no_type():
	var results = PropertyUtil.has_property(self, "_property_2")
	assert_true(results)


func test_object_does_not_have_variant_property_with_type():
	var results = PropertyUtil.has_property(self, "_property_2", TYPE_FLOAT)
	assert_false(results)


