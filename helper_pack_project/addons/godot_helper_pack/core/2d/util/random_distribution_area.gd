tool
class_name RandomDistributionArea, "random_distribution_area.svg"
extends ReferenceRect

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
	#var radius_squared := 1.0
	func _init(_center: Vector2, _radius: float):
		center = _center
		radius = _radius
		#radius_squared = _radius * _radius
	func intersects(other_circle: Circle) -> bool:
		var radii_sum_sq = (radius + other_circle.radius) * (radius + other_circle.radius)
		if center.distance_squared_to(other_circle.center) < radii_sum_sq:
			return true
		return false


class DistributionArea:
	var distribution_radius := 0.0
	var object_radius := 0.0
	var clone_items := []
	var clone_parent: Node
	var object_circles := []
	var discarded_object_circles := []
	var discarded_point_clone_parent: Node
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


class DistributionAreaySorter:
	static func sort_by_distribution_radius_asc(a: DistributionArea, b: DistributionArea) -> bool:
		if a.distribution_radius < b.distribution_radius:
			return true
		return false
	static func sort_by_distribution_radius_desc(a: DistributionArea, b: DistributionArea) -> bool:
		return !sort_by_distribution_radius_asc(a, b)


# parameter for Poisson Disc Sampling
export (int, 1, 500) var num_samples_before_rejection: int = 30
# an update to this property causes the area to be populated at design time
export var populate_area_now: bool setget _update_populate_area
export var clear_area_now: bool setget _set_clear_area_now
export var allow_layer_objects_to_overlap := false
export var allow_runtime_population := false
export (int, 1, 10000) var duplicate_nodes_limit := 2000


var _rand := RandomNumberGenerator.new()


func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if !Engine.editor_hint and !allow_runtime_population:
		for c in get_children():
			remove_child(c)


func _update_populate_area(value):
	if value:
		_populate_area_multi_layer()


func _set_clear_area_now(value) -> void:
	if !value:
		return
	var layers = _get_layers()
	for layer in layers:
		_clear_previous_items(layer.clone_parent)
		if layer.discarded_point_clone_parent != null:
			_clear_previous_items(layer.discarded_point_clone_parent)


func _get_items_to_distribute(n: Node) -> Array:
	var items := []
	for c in n.get_children():
		if c.has_method("_i_am_a_random_distribution_area_layer"):
			continue
		items.append(c)
	return items


func _get_item(item_scene_or_object, parent: Node):
	if item_scene_or_object is PackedScene:
		return item_scene_or_object.instance()
	var item = item_scene_or_object.duplicate(Node.DUPLICATE_SCRIPTS)
	parent.add_child(item)
	item.visible = true
	return item


static func _own(node, new_owner):
	if not node == new_owner and (not node.owner or node.filename):
		node.owner = new_owner
	if node.get_child_count():
		for kid in node.get_children():
			_own(kid, new_owner)


func _get_rand_item(items: Array, parent: Node):
	var index = _rand.randi() % items.size()
	return _get_item(items[index], parent)


func _clear_previous_items(parent: Node):
	for c in parent.get_children():
		parent.remove_child(c)


func _get_layer_nodes() -> Array:
	var layers := []
	for c in get_children():
		if c.has_method("_i_am_a_random_distribution_area_layer") and c.enabled:
			layers.append(c)
	return layers


func _get_layers() -> Array:
	var layer_nodes = _get_layer_nodes()
	var layers := []
	for layer_node in layer_nodes:
		var items = _get_items_to_distribute(layer_node)
		var clone_parent = layer_node.get_clone_parent()
		var discarded_point_clone_parent = layer_node.get_discarded_point_clone_parent()
		var layer = DistributionArea.new(layer_node.distribution_radius, layer_node.object_radius,
			items, clone_parent, discarded_point_clone_parent)
		if layer.clone_items.size() < 1:
			push_error("Need to add children to randomDistributionArea node.")
			continue
		if layer.clone_parent == null:
			push_error("Need to set Distributed Clone Parent.")
			continue
		layers.append(layer)

	if layers.size() < 1:
		push_error("Invalid distribution area data. See previous errors.  Aborting distribution.")

	return layers


func _populate_area_multi_layer() -> void:
	var layers = _get_layers()
	if layers.size() < 1:
		print(name + " must have 1 or more layers in order to populate area.")
		return
	
	_rand.randomize()
	
	print("----------------------------------------------------------------")
	print(name + " - begin populating area")
	yield(get_tree().create_timer(.1), "timeout")
	
	
	var total_stop_watch = StopWatch.new()
	total_stop_watch.start()

	layers.sort_custom(DistributionAreaySorter.new(), "sort_by_distribution_radius_desc")

	var stop_watch = StopWatch.new()
	stop_watch.start()

	var poisson_disc_sampling = PoissonDiscSampling.new()

	for layer in layers:
		_clear_previous_items(layer.clone_parent)
		if layer.discarded_point_clone_parent != null:
			_clear_previous_items(layer.discarded_point_clone_parent)
		var points = poisson_disc_sampling.generate_points(layer.distribution_radius, rect_size,
			num_samples_before_rejection)
		points.sort_custom(Vector2YSorter.new(), "sort")
		layer.populate_object_circles(points)

	stop_watch.stop()

	print(name + " points distributed in msec: " + str(stop_watch.get_elapsed_msec()))
	yield(get_tree().create_timer(.1), "timeout")
	
	
	if layers[0].object_circles.size() > duplicate_nodes_limit:
		print("Number of nodes to duplicate for layer 1 will exceed limit of %d" % duplicate_nodes_limit)
		print("\tTotal duplicate nodes for layer 1: %d" % layers[0].object_circles.size())
		return
		
	var total_to_be_duplicated:int = layers[0].object_circles.size()
	var total_rejected_to_be_duplicated := 0

	if !allow_layer_objects_to_overlap:
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
				total_to_be_duplicated += layer.object_circles.size()
				if layer.discarded_point_clone_parent:
					total_rejected_to_be_duplicated += layer.discarded_object_circles.size()
				if duplicate_nodes_limit > 0 and total_to_be_duplicated + total_rejected_to_be_duplicated > duplicate_nodes_limit:
					print(name + " abandoning overlapping points discard process - exceeded duplidate node limit")
					break
				
		stop_watch.stop()
		print(name + " overlapping points discarded in msec: " + str(stop_watch.get_elapsed_msec()))
		yield(get_tree().create_timer(.1), "timeout")
	else:
		total_to_be_duplicated = 0
		for layer in layers:
			total_to_be_duplicated += layer.object_circles.size()
			if layer.discarded_point_clone_parent:
				total_rejected_to_be_duplicated += layer.discarded_object_circles.size()

	var duplicate_nodes := true
	if duplicate_nodes_limit > 0 and total_to_be_duplicated + total_rejected_to_be_duplicated > duplicate_nodes_limit:
		duplicate_nodes = false
		print("Total number of nodes to duplicate will exceed limit of %d" % duplicate_nodes_limit)
		print("\tTotal duplicate nodes: %d" % total_to_be_duplicated)
		if total_rejected_to_be_duplicated > 0:
			print("\tTotal duplicate nodes (discarded): %d" % total_rejected_to_be_duplicated)

	if duplicate_nodes:
		stop_watch.start()
		var total_number_of_items := 0
		for layer in layers:
			total_number_of_items += layer.object_circles.size()
			for c in layer.object_circles:
				var item = _get_rand_item(layer.clone_items, layer.clone_parent)
				_own(item, get_tree().get_edited_scene_root())
				item.global_position = rect_position + c.center
			if layer.discarded_point_clone_parent != null:
				for c in layer.discarded_object_circles:
					var item = _get_rand_item(layer.clone_items, layer.discarded_point_clone_parent)
					_own(item, get_tree().get_edited_scene_root())
					item.global_position = rect_position + c.center
				layer.discarded_point_clone_parent.visible = false
		stop_watch.stop()
		print(name + " items duplicated and distributed in msec: "
			+ str(stop_watch.get_elapsed_msec()))
		print(name + " number of items duplicated: " + str(total_to_be_duplicated))
	
	
	total_stop_watch.stop()

	print(name + " total elapsed time in msec: " + str(total_stop_watch.get_elapsed_msec()))
