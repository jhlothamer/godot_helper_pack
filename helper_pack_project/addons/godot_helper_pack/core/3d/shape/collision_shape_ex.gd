tool
class_name CollisionShapeEx
extends CollisionShape


signal shape_changed()


func resource_changed(resource: Resource):
	print("CollisionShapeEx: resource changed")
	emit_signal("shape_changed")


func _set(property, value):
	if property == "shape":
		emit_signal("shape_changed")

