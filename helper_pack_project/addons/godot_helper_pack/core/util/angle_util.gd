class_name AngleUtil
extends Object


static func between(angle: float, start_angle: float, end_angle: float) -> bool:
	# degenerate cases
	if start_angle == end_angle or abs(start_angle) == PI and abs(end_angle) == PI:
		return true
	# adapted from from https://stackoverflow.com/questions/42246870/clamp-angle-to-arbitrary-range
	var n_min = wrapf(start_angle - angle, -PI, PI)
	var n_max = wrapf(end_angle - angle, -PI, PI)
	if n_min <= .0 and n_max >= .0:
		return true
	return false


static func clamp_angle(angle: float, start_angle: float, end_angle: float) -> float:
	# degenerate cases
	if start_angle == end_angle or abs(start_angle) == PI and abs(end_angle) == PI:
		return angle
	# taken from https://stackoverflow.com/questions/42246870/clamp-angle-to-arbitrary-range
	var n_min = wrapf(start_angle - angle, -PI, PI)
	var n_max = wrapf(end_angle - angle, -PI, PI)
	if n_min <= .0 and n_max >= .0:
		return angle
	if abs(n_min) < abs(n_max):
		return start_angle
	return end_angle

