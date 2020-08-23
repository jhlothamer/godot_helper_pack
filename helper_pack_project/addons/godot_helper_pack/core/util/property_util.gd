class_name PropertyUtil
extends Object
"""
collection of property utility functions.
"""


# checks if an object has a property and optionally of a given type
static func has_property(obj: Object, property_name: String, property_type: int = -1) -> bool:
	for prop in obj.get_property_list():
		if prop.name == property_name:
			print(str(prop))
			if property_type > -1 && property_type != prop.type:
				return false
			return true
	return false
