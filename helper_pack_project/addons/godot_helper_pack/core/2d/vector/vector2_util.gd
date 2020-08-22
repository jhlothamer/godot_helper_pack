extends Object
class_name Vector2Util


static func closest_angle_to(v1: Vector2, v2: Vector2) -> float:
	var angle = v1.angle_to(v2)
	if angle > PI:
		angle = angle - 2*PI
	elif angle < -PI:
		angle = 2*PI - angle
	return angle


static func closest_angle(angle_diff: float) -> float:
	if angle_diff > PI:
		angle_diff = angle_diff - 2*PI
	elif angle_diff < -PI:
		angle_diff = 2*PI - angle_diff
	return angle_diff


static func midpoint_of(vectors: Array) -> Vector2:
	if(vectors.size() == 0):
		return Vector2.INF
	if typeof(vectors[0]) == TYPE_VECTOR3:
		var midpoint = Vector3.ZERO
		for vector in vectors:
			midpoint += vector
		midpoint /= vectors.size()
		return v3_to_v2(midpoint)
	else:
		var midpoint = Vector2.ZERO
		for vector in vectors:
			midpoint += vector
		midpoint /= vectors.size()
		return midpoint



static func v2_to_v3(v2: Vector2, z: float = 0.0) -> Vector3:
	return Vector3(v2.x, v2.y, z)


static func v3_to_v2(v3: Vector3) -> Vector2:
	return Vector2(v3.x, v3.y)


static func clamp(v: Vector2, top_left: Vector2, bottom_right: Vector2) -> Vector2:
	var clamped_v := Vector2.ZERO
	clamped_v.x = clamp(v.x, top_left.x, bottom_right.x)
	clamped_v.y = clamp(v.y, top_left.y, bottom_right.y)
	return clamped_v









