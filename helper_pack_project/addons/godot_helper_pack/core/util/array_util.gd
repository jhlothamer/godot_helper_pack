class_name ArrayUtil
extends Object
"""
Collection of array utility functions.
"""

# appends all elements from source to dest array
static func append_all(dest: Array, source: Array):
	for item in source:
		dest.append(item)
