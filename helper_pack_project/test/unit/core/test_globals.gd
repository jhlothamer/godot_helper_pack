extends "res://addons/gut/test.gd"


#func before_all():
#	gut.p("Runs once before all tests")
#
#func before_each():
#	gut.p("Runs before each test.")

func after_each():
	Globals.clear()

#func after_all():
#	gut.p("Runs once after all tests")


func get_rand_string(length: int = 20) -> String:
	return Crypto.new().generate_random_bytes(length).get_string_from_ascii()


func test_set_once():
	var property_name = get_rand_string()
	var property_value = get_rand_string(int(rand_range(1.0, 100.0)))
	Globals.set(property_name, property_value)
	var value = Globals.get(property_name)
	assert_eq(value, property_value)


func test_set_twice():
	var property_name = get_rand_string()
	var property_value = get_rand_string(int(rand_range(1.0, 100.0)))
	Globals.set(property_name, property_value)
	property_value = get_rand_string(int(rand_range(1.0, 100.0)))
	Globals.set(property_name, property_value)
	var value = Globals.get(property_name)
	assert_eq(value, property_value)


func test_never_set_returns_null():
	var property_name = get_rand_string()
	var value = Globals.get(property_name)
	assert_null(value)


func test_erase_actually_erases():
	var property_name = get_rand_string()
	var property_value = get_rand_string(int(rand_range(1.0, 100.0)))
	Globals.set(property_name, property_value)
	Globals.erase(property_name)
	var value = Globals.get(property_name)
	assert_null(value)


func test_erase_handles_property_never_set():
	var property_name = get_rand_string()
	Globals.erase(property_name)
	var value = Globals.get(property_name)
	assert_null(value)


func test_get_handles_property_never_set():
	var property_name = get_rand_string()
	var value = Globals.get(property_name)
	assert_null(value)

func test_clear_clears_all():
	var property_name = get_rand_string()
	var property_value = get_rand_string(int(rand_range(1.0, 100.0)))
	Globals.set(property_name, property_value)
	assert_eq(Globals._properties.size(), 1)
	Globals.clear()
	assert_eq(Globals._properties.size(), 0)

