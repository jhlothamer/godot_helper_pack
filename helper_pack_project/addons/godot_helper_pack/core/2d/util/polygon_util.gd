class_name PolygonUtil
extends Node


static func get_midpoint(polygon: PoolVector2Array) -> Vector2:
	var mid_point = Vector2.ZERO
	for v in polygon:
		mid_point += v
	mid_point = mid_point / float(polygon.size())
	return mid_point

