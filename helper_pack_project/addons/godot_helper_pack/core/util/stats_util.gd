class_name StatsUtil
extends Object
"""
Collection of statistic functions.
"""

class Line:
	var b: float
	var m: float

static func sum(measures: Array, limit: int = -1) -> float:
	if measures.size() == 0:
		return INF
	var total := 0.0
	limit = limit if limit > 0 else measures.size()
	for i in range(limit):
		total += float(measures[i])
	return total


static func mean(measures: Array, limit: int = -1) -> float:
	if measures.size() == 0:
		return -1.0
	
	var sum := sum(measures)
		
	limit = limit if limit > 0 else measures.size()

	return sum / float(limit)


static func linear_regression_one_array(measures: Array, limit: int = -1) -> Line:
	if measures.size() == 0:
		return Line.new()
	var x_mean = float(measures.size() - 1) / 2.0
	var y_mean = mean(measures, limit)
	
	var x_minus_x_mean := []
	var y_minus_y_mean := []
	
	limit = limit if limit > 0 else measures.size()
	for i in range(limit):
		var temp = i - x_mean
		x_minus_x_mean.append(temp*temp)
		y_minus_y_mean.append(temp*(measures[i] - y_mean))

	var line = Line.new()
	
	line.m = sum(y_minus_y_mean) / sum(x_minus_x_mean)
	
	line.b = y_mean - line.m * x_mean
	
	return line


static func linear_regression(x_measures: Array, y_measures: Array, limit: int = -1) -> Line:
	limit = limit if limit > 0 else min(x_measures.size(), y_measures.size())
	if x_measures.size() <= 1 or y_measures.size() <= 1:
		return Line.new()
	var x_mean = mean(x_measures)
	var y_mean = mean(y_measures, limit)
	
	var x_minus_x_mean := []
	var y_minus_y_mean := []
	
	for i in range(limit):
		var temp = x_measures[i] - x_mean
		x_minus_x_mean.append(temp*temp)
		y_minus_y_mean.append(temp*(y_measures[i] - y_mean))

	var line = Line.new()
	
	line.m = sum(y_minus_y_mean) / sum(x_minus_x_mean)
	
	line.b = y_mean - line.m * x_mean
	
	return line


