extends Object
class_name Vector2Util
"""
Collection of Vector2 utilities
"""


# checks that given vectors are equal - handled -0 == 0
static func equal(v1: Vector2, v2: Vector2) -> bool:
	return is_equal_approx(v1.x, v2.x) && is_equal_approx(v1.y, v2.y)


# returns closest angle between two vectors
static func closest_angle_to(v1: Vector2, v2: Vector2) -> float:
	var angle = v1.angle_to(v2)
	return closest_angle(angle)


# returns closest angle given the difference of two angles
static func closest_angle(angle_diff: float) -> float:
	if angle_diff > PI:
		angle_diff = angle_diff - 2*PI
	elif angle_diff < -PI:
		angle_diff = 2*PI - angle_diff
	return angle_diff

# returns midpoint of given vectors.  If no vectors given, returns Vector2.INF
static func midpoint_v2(vectors: Array) -> Vector2:
	if(vectors.size() == 0):
		return Vector2.INF
	var midpoint = Vector2.ZERO
	for vector in vectors:
		midpoint += vector
	midpoint /= vectors.size()
	return midpoint


# returns Vector3 where x,y set to given Vector2 plus optional z value which defaults to zero
static func v2_to_v3(v2: Vector2, z: float = 0.0) -> Vector3:
	return Vector3(v2.x, v2.y, z)


# returns Vector2 where x,y set to x,y of Vector3
static func v3_to_v2(v3: Vector3, discard_axis: int = Vector3.AXIS_Z) -> Vector2:
	if discard_axis == Vector3.AXIS_Z:
		return Vector2(v3.x, v3.y)
	if discard_axis == Vector3.AXIS_X:
		return Vector2(v3.y, v3.z)
	return Vector2(v3.x, v3.z)


# clamps a vector between two other vectors that are top left and bottom right
static func clamp(v: Vector2, top_left: Vector2, bottom_right: Vector2) -> Vector2:
	var clamped_v := Vector2.ZERO
	clamped_v.x = clamp(v.x, top_left.x, bottom_right.x)
	clamped_v.y = clamp(v.y, top_left.y, bottom_right.y)
	return clamped_v


# clamps a vector in given Rect2
static func clamp_r(v: Vector2, r: Rect2) -> Vector2:
	var clamped_v := Vector2.ZERO
	clamped_v.x = clamp(v.x, r.position.x, r.end.x)
	clamped_v.y = clamp(v.y, r.position.y, r.end.y)
	return clamped_v

