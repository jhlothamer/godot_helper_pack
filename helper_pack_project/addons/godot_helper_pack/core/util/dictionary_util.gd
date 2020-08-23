class_name DictionaryUtil
extends Object
"""
Collection of dictionary utility functions.
"""


# adds all unique elements from keys array to dictionary with value
static func add_keys(dictionary: Dictionary, keys: Array, value = null) -> void:
	for key in keys:
		if !dictionary.has(key):
			dictionary[key] = value
