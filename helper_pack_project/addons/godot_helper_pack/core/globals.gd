extends Node
## Maintains a dictionary of values.  Property/values persist between scene changes.


var _properties: Dictionary = {}


## adds or changes a property value
func set_value(property_name, value) -> void:
	_properties[property_name] = value


## gets the value of a property.  If the property has not been set, returns null.
func get_value(property_name):
	return _properties.get(property_name)


## removes a property value.
func erase(property_name: String) -> void:
	_properties.erase(property_name)


## removes all property values.
func clear() -> void:
	_properties.clear()

