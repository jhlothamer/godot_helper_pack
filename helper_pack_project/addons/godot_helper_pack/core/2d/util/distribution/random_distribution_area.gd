tool
class_name RandomDistributionArea, "random_distribution_area.svg"
extends ReferenceRect

signal operation_completed()
signal status_updated(status_text)

# this class was created by following along with this excellent video
# https://youtu.be/7WcmyxyFO7o
class PoissonDiscSampling:
	var _rand := RandomNumberGenerator.new()
	func _init():
		_rand.randomize()
	func generate_points(radius: float, sample_region_size: Vector2,
		num_samples_before_rejection: int = 30) -> Array:

		var sample_region_rect: Rect2 = Rect2(Vector2.ZERO, sample_region_size)
		var cell_size : float = radius/sqrt(2)
		var grid := {}
		var spawn_points = []
		var radius_squared = radius*radius
		var loop_counter = 0

		spawn_points.append(sample_region_size/2.0)

		while spawn_points.size() > 0:
			loop_counter += 1
			var spawn_index = _rand.randi() % spawn_points.size()
			var spawn_center = spawn_points[spawn_index]
			var candidate_accepted = false
			for i in range(num_samples_before_rejection):
				var angle : float = _rand.randf_range(-PI, PI)
				var dir = Vector2.RIGHT.rotated(angle)
				var candidate_vector: Vector2 = spawn_center + dir * _rand.randf_range(radius, 2.0*radius)
				if !sample_region_rect.has_point(candidate_vector):
					continue
				var grid_coord: Vector2 = Vector2(int(candidate_vector.x/cell_size),
					int(candidate_vector.y/cell_size))
				if(is_valid(candidate_vector,  grid_coord, grid, radius_squared)):
					spawn_points.append(candidate_vector)
					grid[grid_coord] = candidate_vector
					candidate_accepted = true
					break
			if !candidate_accepted:
				spawn_points.remove(spawn_index)

		return grid.values()

	func is_valid(candidate_vector, candidate_grid_coord: Vector2, grid: Dictionary,
		radius_squared: float) -> bool:

		var search_start_x = candidate_grid_coord.x - 2
		var search_end_x = candidate_grid_coord.x + 2
		var search_start_y = candidate_grid_coord.y - 2
		var search_end_y = candidate_grid_coord.y + 2

		for x in range(search_start_x, search_end_x+1):
			for y in range(search_start_y, search_end_y+1):
				var grid_coord := Vector2(x, y)
				if grid_coord in grid:
					var grid_pt: Vector2 = grid[grid_coord]
					var distance_squared = candidate_vector.distance_squared_to(grid_pt)
					if distance_squared < radius_squared:
						return false

		return true


class Vector2YSorter:
	static func sort(a: Vector2, b: Vector2) -> bool:
		if a.y < b.y:
			return true
		return false


class Circle:
	var center := Vector2.ZERO
	var radius := 1.0
	func _init(_center: Vector2, _radius: float):
		center = _center
		radius = _radius
	func intersects(other_circle: Circle) -> bool:
		var radii_sum_sq = (radius + other_circle.radius) * (radius + other_circle.radius)
		if center.distance_squared_to(other_circle.center) < radii_sum_sq:
			return true
		return false


class DistributionAreaLayer:
	var distribution_radius := 0.0
	var object_radius := 0.0
	var clone_items := []
	var clone_parent: Node
	var object_circles := []
	var discarded_object_circles := []
	var discarded_point_clone_parent: Node
	var exclusion_polygons := []
	func _init(_distribution_radius: float, _object_radius: float, _clone_items: Array,
		_clone_parent: Node, _discarded_point_clone_parent: Node):
		distribution_radius = _distribution_radius
		object_radius = _object_radius
		clone_items = _clone_items
		clone_parent = _clone_parent
		discarded_point_clone_parent = _discarded_point_clone_parent
	func populate_object_circles(distribution_points: Array) -> void:
		for pt in distribution_points:
			object_circles.append(Circle.new(pt, object_radius))
	func discard_excluded_points() -> void:
		var kept_object_circles := []
		for i in object_circles:
			var oc:Circle = i
			var discard := false
			for j in exclusion_polygons:
				if Geometry.is_point_in_polygon(oc.center, j):
					discard = true
					break
			if !discard:
				kept_object_circles.append(oc)
		object_circles = kept_object_circles


class DistributionAreaLayerSorter:
	static func sort_by_distribution_radius_asc(a: DistributionAreaLayer, b: DistributionAreaLayer) -> bool:
		if a.distribution_radius < b.distribution_radius:
			return true
		return false
	static func sort_by_distribution_radius_desc(a: DistributionAreaLayer, b: DistributionAreaLayer) -> bool:
		return !sort_by_distribution_radius_asc(a, b)


# parameter for Poisson Disc Sampling
export (int, 1, 500) var num_samples_before_rejection: int = 30
export var allow_layer_objects_to_overlap := false
export var allow_runtime_population := false
export (int, 1, 10000) var duplicate_nodes_limit := 2000
export var sort_y := false
export var exclusion_polygon_node_group := "exclusion_polygon"


var status := ""

var _rand := RandomNumberGenerator.new()


func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if !Engine.editor_hint and !allow_runtime_population:
		for c in get_children():
			if c.has_method("_i_am_a_random_distribution_area_layer"):
				remove_child(c)
			else:
				printerr("RandomDistributionArea: node not RandomDistributionAreaLayer.  Please move.  %s" % c.get_path())


func clear_distribution() -> void:
	var layers = _get_layers()
	for layer in layers:
		NodeUtil.remove_children(layer.clone_parent)
		if layer.discarded_point_clone_parent != null:
			NodeUtil.remove_children(layer.discarded_point_clone_parent)


func _get_item(item_scene_or_object, parent: Node):
	var item: CanvasItem
	if item_scene_or_object is PackedScene:
		item =  item_scene_or_object.instance()
	else:
		item = item_scene_or_object.duplicate(Node.DUPLICATE_SCRIPTS)
	parent.add_child(item)
	item.visible = true
	return item


func _get_rand_item(items: Array, parent: Node):
	var index = _rand.randi() % items.size()
	return _get_item(items[index], parent)

func _get_exclusion_polygons(group_name: String) -> Array:
	var polygons := []
	if group_name.empty():
		return polygons
	for i in get_tree().get_nodes_in_group(group_name):
		if !i is Polygon2D:
			continue
		var t := Transform2D(0.0, i.global_position)
		polygons.append(t.xform(i.polygon))
	return polygons


func _get_layer_nodes() -> Array:
	var layers := []
	for c in get_children():
		if c.has_method("_i_am_a_random_distribution_area_layer") and c.enabled:
			layers.append(c)
	return layers


func _get_layers() -> Array:
	var global_exclusion_polygons = _get_exclusion_polygons(exclusion_polygon_node_group)
	var polygons_by_layer_group_name := {}
	var layer_nodes = _get_layer_nodes()
	var layers := []
	for layer_node in layer_nodes:
		var items = layer_node.get_items_to_distribute()
		if items.size() < 1:
			continue
		var clone_parent = layer_node.get_clone_parent()
		if !clone_parent:
			continue
		var discarded_point_clone_parent = layer_node.get_discarded_point_clone_parent()
		var layer = DistributionAreaLayer.new(layer_node.distribution_radius, layer_node.object_radius,
			items, clone_parent, discarded_point_clone_parent)
		if global_exclusion_polygons.size() > 0:
			layer.exclusion_polygons.append_array(global_exclusion_polygons)
		if !layer_node.layer_exclusion_polygon_node_group.empty():
			if !polygons_by_layer_group_name.has(layer_node.layer_exclusion_polygon_node_group):
				polygons_by_layer_group_name[layer_node.layer_exclusion_polygon_node_group] = _get_exclusion_polygons(layer_node.layer_exclusion_polygon_node_group)
			layer.exclusion_polygons.append_array(polygons_by_layer_group_name[layer_node.layer_exclusion_polygon_node_group])
		layers.append(layer)

	if layers.size() < 1:
		push_error("RandomDistributionArea: Invalid distribution area data. See previous errors.  Aborting distribution.")

	layers.sort_custom(DistributionAreaLayerSorter.new(), "sort_by_distribution_radius_desc")

	return layers


func _generate_layer_points(layers: Array) -> int:
	var stop_watch = StopWatch.new()
	stop_watch.start()

	var poisson_disc_sampling = PoissonDiscSampling.new()
	var total_point_count := 0
	for layer in layers:
		NodeUtil.remove_children(layer.clone_parent)
		if layer.discarded_point_clone_parent != null:
			NodeUtil.remove_children(layer.discarded_point_clone_parent)
		
		var points = poisson_disc_sampling.generate_points(layer.distribution_radius, rect_size,
			num_samples_before_rejection)
		if sort_y:
			points.sort_custom(Vector2YSorter.new(), "sort")
		layer.populate_object_circles(points)
		total_point_count += points.size()

	stop_watch.stop()

	status += "\tpoints distributed in %d msec\r\n" % stop_watch.get_elapsed_msec()
	status += "\t\ttotal number of points (all layers): %d\r\n" % total_point_count
	emit_signal("status_updated", status)
	return total_point_count

func _discard_excluded_points(layers: Array) -> int:
	var stop_watch = StopWatch.new()
	stop_watch.start()
	var total_point_count := 0
	for layer in layers:
		layer.discard_excluded_points()
		total_point_count += layer.object_circles.size()
	stop_watch.stop()

	status += "\tpoints excluded in %d msec\r\n" % stop_watch.get_elapsed_msec()
	status += "\t\ttotal number of points after exclusion: %d\r\n" % total_point_count
	emit_signal("status_updated", status)
	return total_point_count


func _discard_overlapping_object(layers: Array) -> void:
	var stop_watch := StopWatch.new()
	stop_watch.start()
	# scan previous layers for overlapping object circles - removing current layer object circles
	for i in range(1, layers.size()):
		var layer = layers[i]
		for k in range(0, i):
			var other_layer = layers[k]
			var kept_layer_object_circles := []
			for layer_object_circle in layer.object_circles:
				var keep_layer_object_circle := true
				for other_layer_object_circle in other_layer.object_circles:
					if layer_object_circle.intersects(other_layer_object_circle):
						keep_layer_object_circle = false
						break
				if keep_layer_object_circle:
					kept_layer_object_circles.append(layer_object_circle)
				else:
					layer.discarded_object_circles.append(layer_object_circle)
			layer.object_circles = kept_layer_object_circles
			
	stop_watch.stop()
	status += "\toverlapping points discarded in %d msec\r\n" % stop_watch.get_elapsed_msec()
	emit_signal("status_updated", status)

func _duplicate_layer_items(layers: Array) -> void:
	var total_number_of_items := 0
	var stop_watch = StopWatch.new()
	stop_watch.start()
	for layer in layers:
		total_number_of_items += layer.object_circles.size()
		for c in layer.object_circles:
			var item = _get_rand_item(layer.clone_items, layer.clone_parent)
			item.owner = get_tree().get_edited_scene_root()
			item.global_position = rect_position + c.center
		if layer.discarded_point_clone_parent != null:
			for c in layer.discarded_object_circles:
				var item = _get_rand_item(layer.clone_items, layer.discarded_point_clone_parent)
				item.owner = get_tree().get_edited_scene_root()
				item.global_position = rect_position + c.center
			layer.discarded_point_clone_parent.visible = false
	stop_watch.stop()
	status += "\titems duplicated in %d msec\r\n" % stop_watch.get_elapsed_msec()
	status += "\tnumber of items duplicated: %d\r\n" % total_number_of_items
	emit_signal("status_updated", status)


func do_distribution() -> void:
	yield(get_tree(), "idle_frame")
	var layers = _get_layers()
	if layers.size() < 1:
		#print(name + " must have 1 or more layers in order to populate area.")
		status = "RandomDistributionArea: must have > 0 (enabled) RandomDistributionAreaLayer children"
		emit_signal("operation_completed")
		return
	
	_rand.randomize()
	
	status = "RandomDistributionArea: starting distribution process.\r\n"
	emit_signal("status_updated", status)
	
	var total_point_count = _generate_layer_points(layers)
	yield(get_tree(), "idle_frame")
	
	_discard_excluded_points(layers)
	yield(get_tree(), "idle_frame")
	
	var total_stop_watch = StopWatch.new()
	total_stop_watch.start()
	
	# check first layer (with biggest object radius) to see if we're already over duplicate node limit
	if layers[0].object_circles.size() > duplicate_nodes_limit:
		status += "\tNumber of nodes to duplicate for layer 1 will exceed limit of %d\r\n" % duplicate_nodes_limit
		status += "\t\tTotal duplicate nodes for layer 1: %d\r\n" % layers[0].object_circles.size()
		emit_signal("operation_completed")
		return

	if !allow_layer_objects_to_overlap:
		_discard_overlapping_object(layers)
		yield(get_tree(), "idle_frame")
	
	var total_to_be_duplicated := 0
	var total_rejected_to_be_duplicated := 0
	var total_rejected := 0
	for i in layers.size():
		var layer:DistributionAreaLayer = layers[i]
		total_to_be_duplicated += layer.object_circles.size()
		total_rejected += layer.discarded_object_circles.size()
		if layer.discarded_point_clone_parent:
			total_rejected_to_be_duplicated += layer.discarded_object_circles.size()

	var duplicate_nodes := true
	if duplicate_nodes_limit > 0 and total_to_be_duplicated + total_rejected_to_be_duplicated > duplicate_nodes_limit:
		duplicate_nodes = false
		status += "\tTotal number of nodes to duplicate will exceed limit of %d\r\n" % duplicate_nodes_limit
	
	status += "\t\tTotal duplicate nodes: %d\r\n" % (total_point_count - total_rejected)
	if allow_layer_objects_to_overlap:
		status += "\t\tNo nodes rejected for overlap - overlapping allowed"
	else:
		status += "\t\tTotal nodes rejected for overlap: %d\r\n" % total_rejected
	emit_signal("status_updated", status)

	yield(get_tree(), "idle_frame")

	if duplicate_nodes:
		_duplicate_layer_items(layers)
	
	total_stop_watch.stop()

	status += "\ttotal elapsed time in %d msec\r\n" % total_stop_watch.get_elapsed_msec()
	emit_signal("operation_completed")
