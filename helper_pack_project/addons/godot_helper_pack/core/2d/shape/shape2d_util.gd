class_name Shape2DUtil
extends Object


static func make_polygon_from_shape(shape2d: Shape2D, var point_count:int = 100) -> Array:
	var polygon: Array
	
	if !shape2d:
		printerr("shape2d is null.")
	elif shape2d is RectangleShape2D:
		var rs:RectangleShape2D = shape2d
		var rect := Rect2(-1.0*rs.extents, 2.0*rs.extents)
		polygon = Rect2Util.make_polygon(rect)
	elif shape2d is CircleShape2D:
		var cs: CircleShape2D = shape2d
		var a := 2.0*PI/float(point_count)
		var v := Vector2.RIGHT*cs.radius
		for i in range(point_count):
			polygon.append(v)
			v = v.rotated(a)
	elif shape2d is ConvexPolygonShape2D:
		var cps:ConvexPolygonShape2D = shape2d
		polygon = cps.points
	elif shape2d is ConcavePolygonShape2D:
		var cps:ConcavePolygonShape2D = shape2d
		polygon = cps.segments
	elif shape2d is CapsuleShape2D:
		var cs:CapsuleShape2D = shape2d
		var a := 2.0*PI/float(point_count)
		var v := Vector2.RIGHT*cs.radius
		var c1center := Vector2.UP*(cs.height/2.0)
		var c2center := -1.0*c1center
		var pts := []
		for i in range(point_count):
			pts.append(v+c1center)
			pts.append(v+c2center)
			v = v.rotated(a)
		polygon = Geometry.convex_hull_2d(pts)
	else:
		printerr("Unhandled shape 2d class: %s" % shape2d.get_class())
	return polygon

