class_name Rect2Util
extends Node

static func make_polygon(r: Rect2) -> Array:
	var pts = []
	#top right
	pts.append(Vector2(r.end.x, r.position.y))
	#bottom right
	pts.append(r.end)
	#bottom left
	pts.append(Vector2(r.position.x, r.end.y))
	#top left
	pts.append(r.position)
	return pts
