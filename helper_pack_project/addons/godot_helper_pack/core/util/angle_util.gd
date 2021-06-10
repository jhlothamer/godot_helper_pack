class_name AngleUtil
extends Object


# checks if an angle is between a start and end angle
# all angles must be between or equal to +/- PI
static func between(angle: float, start_angle: float, end_angle: float) -> bool:
	assert(-PI <= start_angle and start_angle <= PI)
	assert(-PI <= end_angle and end_angle <= PI)
	assert(-PI <= angle and angle <= PI)

	# make end angle greater than start angle
	if end_angle < start_angle:
		end_angle += TAU
	
	# if angle already not greater than start angle
	if angle < start_angle:
		# add 2PI to it - maybe it is now
		angle += TAU
	
	return (start_angle <= angle) and (angle <= end_angle)


static func clamp_angle(angle: float, start_angle: float, end_angle: float) -> float:
	if between(angle, start_angle, end_angle):
		return angle
	
	#since angle is not between - use it's opposite to decide which end angle to use
	var opposite_angle := wrapf(angle + PI, -PI, PI)
	
	if abs(opposite_angle - start_angle) < abs(opposite_angle - end_angle):
		return end_angle
	
	return start_angle

