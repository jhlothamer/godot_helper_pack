tool
class_name MultiMeshInstanceDistributionArea
extends ReferenceRect

signal operation_completed()


export var multi_mesh_instance_2d: NodePath
export var mesh_instance_2d: NodePath
export var static_body_2d: NodePath
export (float, 10.0, 10000.0) var distribution_radius := 100.0

export var exclusion_polygon_node_group := "exclusion_polygon"
export var static_body_only_node_group := "static_body_only"
export var distribution_only_node_group := "distribution_only"
export var exclusion_polygon_group_node_group := "exclusion_polygon_group"

var status := ""


var _mmi: MultiMeshInstance2D
var _mi: MeshInstance2D
var _sb: StaticBody2D
var _carving_polygons := []
var _additional_carving_polygons := []
var _additional_distribution_carving_polygons := []


func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _refresh_references():
	_mmi = null
	_mi = null
	_sb = null
	_carving_polygons.clear()
	_additional_carving_polygons.clear()
	_additional_distribution_carving_polygons.clear()
	
	var temp = get_node(multi_mesh_instance_2d)
	if temp and temp is MultiMeshInstance2D:
		_mmi = temp
	temp = get_node(mesh_instance_2d)
	if temp and temp is MeshInstance2D:
		_mi = temp
	temp = get_node_or_null(static_body_2d)
	if temp and temp is StaticBody2D:
		_sb = temp
	
	if !exclusion_polygon_node_group.empty():
		for i in get_tree().get_nodes_in_group(exclusion_polygon_node_group):
			if !i is Polygon2D:
				continue
			_process_exclusion_polygon(i)

	if !exclusion_polygon_group_node_group.empty():
		for i in get_tree().get_nodes_in_group(exclusion_polygon_group_node_group):
			for j in i.get_children():
				if !j is Polygon2D:
					continue
				_process_exclusion_polygon(j)


func _process_exclusion_polygon(polygon2d: Polygon2D) -> void:
			var t := Transform2D(0.0, polygon2d.global_position)
			if polygon2d.is_in_group(static_body_only_node_group):
				_additional_carving_polygons.append(t.xform(polygon2d.polygon))
			elif polygon2d.is_in_group(distribution_only_node_group):
				_additional_distribution_carving_polygons.append(t.xform(polygon2d.polygon))
			else:
				_carving_polygons.append(t.xform(polygon2d.polygon))


func _get_region_rect() -> Rect2:
	return Rect2(rect_global_position, rect_size)


func _clear_distribution():
	_refresh_references()
	if !_mmi:
		status = "MultiMeshInstanceDistribution: missing or bad nodepaths.  Please check nodepath properties."
		return
	_mmi.multimesh.instance_count = 0


func _do_distribution():
	_refresh_references()
	if !_mmi or !_mi:
		status = "MultiMeshInstanceDistribution: missing or bad nodepaths.  Please check nodepath properties."
		return
	
	_carving_polygons.append_array(_additional_distribution_carving_polygons)
	
	var sw := StopWatch.new()
	sw.start()

	if !_mmi.texture:
		_mmi.texture = _mi.texture
	
	var swSampling := StopWatch.new()
	swSampling.start()
	var sample_region = _get_region_rect()
	var pds := RandomDistributionArea.PoissonDiscSampling.new()
	var distrib_pts := pds.generate_points(distribution_radius, sample_region.size)
	var t := Transform2D(0.0, sample_region.position)
	distrib_pts = t.xform(PoolVector2Array(distrib_pts))
	swSampling.stop()
	var starting_distrib_pt_count = distrib_pts.size()
	
	var swCarving := StopWatch.new()
	swCarving.start()
	var pts_kept := []
	for pt in distrib_pts:
		var discard := false
		for poly in _carving_polygons:
			if Geometry.is_point_in_polygon(pt, poly):
				discard = true
				break
		if !discard:
			pts_kept.append(pt)
	swCarving.stop()

	var swSetTransforms := StopWatch.new()
	swSetTransforms.start()
	var rand := RandomNumberGenerator.new()
	rand.randomize()
	var multi_mesh := MultiMesh.new()
	_mmi.multimesh = multi_mesh
	multi_mesh.mesh = _mi.mesh
	var mmi_transform = Transform2D(0.0, -_mmi.global_position)
	pts_kept = mmi_transform.xform(PoolVector2Array(pts_kept))
	multi_mesh.instance_count = pts_kept.size()
	for i in multi_mesh.instance_count:
		var pt = pts_kept[i]
		var ptt = Transform2D(rand.randf()*TAU, pt)
		multi_mesh.set_instance_transform_2d(i, ptt)
	swSetTransforms.stop()
	
	sw.stop()
	
	status = "MultiMeshInstanceDistribution: distribution complete.\r\n"
	status += "\tStats:\r\n"
	status += "\t\tduration total: %f ms\r\n" % sw.get_elapsed_msec()
	status += "\t\tduration sampling: %f ms\r\n" % swSampling.get_elapsed_msec()
	status += "\t\tduration carving: %f ms\r\n" % swCarving.get_elapsed_msec()
	status += "\t\tduration set transform: %f ms\r\n" % swSetTransforms.get_elapsed_msec()
	status += "\t\tstarting distributed point count: %d\r\n" % starting_distrib_pt_count
	status += "\t\tending distributed point count: %d" % pts_kept.size()

	emit_signal("operation_completed")


func _get_mesh_polygon() -> Array:
	var shape = _mi.mesh.create_convex_shape()
	var pts = []
	for v3 in shape.points:
		var v2 = Vector2(v3.x, v3.y)
		pts.append(v2)
	pts = Geometry.convex_hull_2d(pts)
	return pts

func _make_box_polygon(r: Rect2) -> Array:
	return [
		r.position,
		r.position + Vector2(r.size.x, 0),
		r.position + r.size,
		r.position + Vector2(0, r.size.y),
	]

func _clear_static_body_collision_shapes():
	_refresh_references()
	if!_sb:
		status = "MultiMeshInstanceDistribution: missing or bad nodepaths.  Please check nodepath properties."
		return
	for c in _sb.get_children():
		if c is CollisionPolygon2D:
			c.queue_free()


func _generate_static_body_collision_shapes():
	_refresh_references()
	if !_mmi or !_mi or !_sb:
		status = "MultiMeshInstanceDistribution: missing or bad nodepaths.  Please check nodepath properties."
		return
	
	_carving_polygons.append_array(_additional_carving_polygons)
	
	#_generate_shapes_exact()
	_generate_shapes_simple()

# This algorithm joins the distributed polygons together to get an exact match for
# the static body collision polygons.  BUT this results in bad physics performance
# and can even crash the editor by exceeding the max number of pooled vector2 arrays.
# Leaving this in hoping to get back to this one day and develop something that works,
# maybe using some sort of polygon simplification and changing the algorithm to not create
# so many pooled vector2 arrays.
func _generate_shapes_exact():
	if _mmi.multimesh.instance_count > 100000:
		status = "MultiMeshInstanceDistribution: too many mesh instances.  Cannot create exact collision shapes.  Mesh instance count: %d" % _mmi.multimesh.instance_count
		return
	var sw := StopWatch.new()
	sw.start()
	
	var mesh_poly := _get_mesh_polygon()
	
	var polygons := []
	
	var multi_mesh := _mmi.multimesh
	
	status = "MultiMeshInstanceDistribution: number of polygons to process: %d" % multi_mesh.instance_count
	emit_signal("operation_completed")
	return
	
	for i in multi_mesh.instance_count:
		var t := multi_mesh.get_instance_transform_2d(i)
		polygons.append(t.xform(mesh_poly))
	
	var starting_polygon_count := polygons.size()
	
	var count_since_last_join := 0
	var runaway_counter = 0
	while count_since_last_join < polygons.size() and runaway_counter < 200:
		runaway_counter += 1
		var curr_poly = polygons.pop_front()
		var i = 0
		while i < polygons.size():
			var poly = polygons[i]
			var intersection = Geometry.intersect_polygons_2d(curr_poly, poly)
			if intersection:
				polygons.erase(poly)
				curr_poly = Geometry.merge_polygons_2d(curr_poly, poly)[0]
				count_since_last_join = 0
				continue
			count_since_last_join += 1
			i += 1
		polygons.append(curr_poly)
	
	for c in _sb.get_children():
		if c is CollisionPolygon2D:
			c.queue_free()
	
	for p in polygons:
		var c := CollisionPolygon2D.new()
		c.polygon = p
		_sb.add_child(c)
		c.owner = get_tree().get_edited_scene_root()
	
	sw.stop()
	status = "MultiMeshInstanceDistribution: collision shape generation (exact) complete.\r\n"
	status += "\tStats:\r\n"
	status += "\t\tduration: %f ms\r\n" % sw.get_elapsed_msec()
	status += "\t\tstarting polygon count: %d\r\n" % starting_polygon_count
	status += "\t\tending polygon count: %d\r\n" % polygons.size()
	emit_signal("operation_completed")


func _generate_shapes_simple():
	var sw := StopWatch.new()
	sw.start()
	var r = _get_region_rect()
	var region_polygon = _make_box_polygon(r)
	
	var collision_polygons := [region_polygon]
	
	var loop_limit = _carving_polygons.size() * 2
	var loop_count = 0
	var starting_carve_poly_count:int = _carving_polygons.size()
	var total_loop_count = 0
	while _carving_polygons and loop_count < loop_limit:
		loop_count += 1
		var carve_poly = _carving_polygons.pop_front()
		var new_collsion_polygons := []
		var new_col_poly_created := false
		while collision_polygons:
			total_loop_count += 1
			var col_poly = collision_polygons.pop_front()
			var intersection = Geometry.intersect_polygons_2d(carve_poly, col_poly)
			if !intersection:
				new_collsion_polygons.append(col_poly)
				continue
			var clip_results = Geometry.clip_polygons_2d(col_poly, carve_poly)
			var have_hole := false
			for cr in clip_results:
				have_hole = Geometry.is_polygon_clockwise(cr)
				if have_hole:
					break
			if !have_hole:
				new_col_poly_created = true
				new_collsion_polygons.append_array(clip_results)
			else:
				new_collsion_polygons.append(col_poly)
		collision_polygons.append_array(new_collsion_polygons)
		# if no new polygons created for carve polygon - re-add it to process again later
		if !new_col_poly_created:
			_carving_polygons.append(carve_poly)

	for c in _sb.get_children():
		if c is CollisionPolygon2D:
			c.queue_free()

	var sb_transform = Transform2D(0.0, -_sb.global_position)
	for col_poly in collision_polygons:
		var c := CollisionPolygon2D.new()
		c.polygon = sb_transform.xform(col_poly)
		_sb.add_child(c)
		c.owner = get_tree().get_edited_scene_root()

	sw.stop()
	status ="MultiMeshInstanceDistribution: collision shape generation (simple) complete.\r\n"
	status += "\tStats:\r\n"
	status += "\t\tduration: %f ms\r\n" % sw.get_elapsed_msec()
	status += "\t\tcarve polys start: %d\r\n" % starting_carve_poly_count
	status += "\t\tcarve polys end: %d\r\n" % _carving_polygons.size()
	status += "\t\tcoll polys end: %d\r\n" % collision_polygons.size()
	status += "\t\tloop count: %d , loop limit: %d\r\n" % [loop_count, loop_limit]
	status += "\t\ttotal loop count: %d\r\n" % total_loop_count
	emit_signal("operation_completed")


func _calc_compact_distribution_radius() -> void:
	_refresh_references()
	if !_mi:
		status = "MultiMeshInstanceDistribution: please assign the mesh instance property"
		return
	
	if _mi.mesh.get_surface_count() != 1:
		status = "MultiMeshInstanceDistribution: no surface vertices"
		return
	
	var array = _mi.mesh.surface_get_arrays(0)
	var vertices: Array = array[ArrayMesh.ARRAY_VERTEX]
	
	var mid_pt := PolygonUtil.get_midpoint(vertices)
	
	var min_d := INF
	
	for i in vertices:
		var v: Vector2 = i
		var d = v.distance_to(mid_pt)
		if d < min_d:
			min_d = d
	
	min_d = ceil(min_d)
	distribution_radius = min_d
	
	status = "MultiMeshInstanceDistribution: Distribution radius set to %d" % min_d


