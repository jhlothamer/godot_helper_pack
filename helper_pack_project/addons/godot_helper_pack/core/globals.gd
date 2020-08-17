extends Node

"""
Globals dictionary.  To use add to the auto-load list for the project.
"""

var _properties: Dictionary = {}


# adds or changes a property value
func set(property_name: String, value) -> void:
	_properties[property_name] = value


# gets the value of a property.  If the property has not been set, returns null.
func get(property_name: String):
	if !_properties.has(property_name):
		return null
	return _properties[property_name]


# removes the property value.
func erase(property_name: String) -> void:
	_properties.erase(property_name)


# removes all property values.
func clear() -> void:
	_properties.clear()

