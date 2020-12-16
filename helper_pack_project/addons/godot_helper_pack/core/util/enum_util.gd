class_name EnumUtil
extends Object
"""
Collection of enum utility.
"""

static func get_id(enum_class: Dictionary, enum_string: String) -> int:
	if !enum_class.has(enum_string):
		printerr("given enum string is not in enum class")
		return -1
	return enum_class[enum_string]


static func get_string(enum_class: Dictionary, enum_int_value: int) -> String:
	var keys = enum_class.keys()
	if enum_int_value < 0 or enum_int_value >= keys.size():
		printerr("given enum int value out of range for enum class")
		return ""
	return keys[enum_int_value]


static func get_array(enum_class: Dictionary) -> Array:
	return enum_class.values()

static func get_names_string_array(enum_class: Dictionary) -> Array:
	return enum_class.keys()

