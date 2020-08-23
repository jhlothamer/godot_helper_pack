class_name StringUtil
extends Object
"""
Collection of string utility functions.
"""


# gets file name without extension
static func get_file_name(s: String) -> String:
	var file_name = s.get_file()
	if !is_null_or_empty(file_name):
		var extension = s.get_extension()
		if !is_null_or_empty(extension):
			file_name = file_name.left(file_name.length() - extension.length() - 1)
	return file_name


# returns true if string is null or empty
static func is_null_or_empty(s: String) -> bool:
	return s == null or s == ""
