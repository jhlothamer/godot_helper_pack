class_name ArrayUtil
extends Object
"""
Collection of array utility functions.
"""

# appends all elements from source to dest array
static func append_all(dest: Array, source: Array):
	for item in source:
		dest.append(item)


static func get_rand(a: Array):
	if a.size() == 0:
		return null
	return a[int(rand_range(0, a.size())) % a.size()]


static func has_any(a: Array, b: Array) -> bool:
	for b_item in b:
		if a.has(b_item):
			return true
	return false


static func has_all(a: Array, b: Array) -> bool:
	for b_item in b:
		if !a.has(b_item):
			return false
	return true


static func intersection(a: Array, b: Array) -> Array:
	var i := []
	for b_item in b:
		if !a.has(b_item):
			i.append(b_item)
	return i
