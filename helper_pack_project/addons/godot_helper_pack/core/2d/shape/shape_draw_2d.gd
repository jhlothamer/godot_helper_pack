@tool
class_name ShapeDraw2D
extends Node2D

enum AxisStretchMode {
	STRETCH,
	TILE,
	TILE_FIT
}

var color: Color = Color(1.0,1.0,1.0,1.0) :
	set(mod_value):
		color = mod_value
		if _polygon != null and !texture:
			_polygon.color = mod_value
		else:
			queue_redraw()
var texture: Texture2D :
	set(mod_value):
		texture = mod_value
		_process_parent_shape()
		queue_redraw()

# applies to all but rect
var non_rect_texture_offset := Vector2.ZERO :
	set(mod_value):
		non_rect_texture_offset = mod_value
		if _polygon:
			_polygon.texture_scale = Vector2.ONE / non_rect_texture_scale
var non_rect_texture_scale := Vector2.ONE :
	set(mod_value):
		non_rect_texture_scale = mod_value
		if _polygon:
			_polygon.texture_scale = Vector2.ONE / non_rect_texture_scale
			non_rect_texture_offset = non_rect_texture_offset

# applies to rectangle shape - for nine patch
var nine_patch_draw_center := true :
	set(mod_value):
		nine_patch_draw_center = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.draw_center = mod_value
var nine_patch_region_rect: Rect2 :
	set(mod_value):
		nine_patch_region_rect = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.region_rect = mod_value
var nine_patch_patch_left := 0 :
	set(mod_value):
		nine_patch_patch_left = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_left = mod_value
var nine_patch_patch_right := 0 :
	set(mod_value):
		nine_patch_patch_right = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_right = mod_value
var nine_patch_patch_top := 0 :
	set(mod_value):
		nine_patch_patch_top = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_top = mod_value
var nine_patch_patch_bottom := 0 :
	set(mod_value):
		nine_patch_patch_bottom = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_bottom = mod_value
var nine_patch_axis_stretch_horizontal: NinePatchRect.AxisStretchMode :
	set(mod_value):
		nine_patch_axis_stretch_horizontal = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.axis_stretch_horizontal = mod_value
var nine_patch_axis_stretch_vertical: NinePatchRect.AxisStretchMode :
	set(mod_value):
		nine_patch_axis_stretch_vertical = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.axis_stretch_vertical = mod_value


var _shape: Shape2D
var _polygon: Polygon2D
var _polygon_midpt: Vector2
var _nine_patch_rect: NinePatchRect


func _ready():
	_process_parent_shape()
	if Engine.is_editor_hint():
		get_parent().connect("draw",Callable(self,"_on_draw"))


func _process_parent_shape():
	if !is_inside_tree():
		return
	var parent = get_parent()
	if parent is CollisionShape2D:
		if parent.shape is ConvexPolygonShape2D:
			_create_polygon_2d(parent.shape.points)
		elif parent.shape is ConcavePolygonShape2D:
			_create_polygon_2d(parent.shape.segments)
		elif parent.shape is CapsuleShape2D:
			var shape_polygon = Shape2DUtil.make_polygon_from_shape(parent.shape)
			_create_polygon_2d(shape_polygon)
		elif parent.shape is CircleShape2D and texture:
			var shape_polygon = Shape2DUtil.make_polygon_from_shape(parent.shape, 500)
			_create_polygon_2d(shape_polygon)
		elif parent.shape is RectangleShape2D and texture:
				_create_nine_patch_rect(parent.shape)
		else:
			_shape = parent.shape
			if _polygon:
				_polygon.queue_free()
				_polygon = null
			if _nine_patch_rect:
				_nine_patch_rect.queue_free()
				_nine_patch_rect = null
	elif parent is CollisionPolygon2D:
		_create_polygon_2d(parent.polygon)
	else:
		push_error("Parent of ShapeDraw2D must be CollisionShape2D or CollisionPolygon2D.")
	

func _create_polygon_2d(p: PackedVector2Array) -> void:
	_shape = null
	if _nine_patch_rect:
		_nine_patch_rect.queue_free()
		_nine_patch_rect = null
	if !_polygon:
		_polygon = Polygon2D.new()
		add_child(_polygon)
	_polygon.polygon = PackedVector2Array(p)
	if !texture:
		_polygon.color = color
	_polygon.texture = texture
	if texture:
		_polygon_midpt = Vector2Util.midpoint_v2(p)
		if _polygon_midpt == Vector2(INF, INF):
			_polygon_midpt = Vector2.ZERO
		_polygon_midpt *= -1.0
		_polygon.texture_offset = _polygon_midpt + (texture.get_size() / 2.0 - non_rect_texture_offset) * non_rect_texture_scale
		_polygon.texture_scale = Vector2.ONE / non_rect_texture_scale


func _create_nine_patch_rect(rect_shape: RectangleShape2D) -> void:
	_shape = null
	if _polygon:
		_polygon.queue_free()
		_polygon = null
	if !_nine_patch_rect:
		_nine_patch_rect = NinePatchRect.new()
		add_child(_nine_patch_rect)
	
	_nine_patch_rect.position = -rect_shape.extents
	_nine_patch_rect.size = 2*rect_shape.extents
	
	_nine_patch_rect.texture = texture
	_nine_patch_rect.draw_center = nine_patch_draw_center
	_nine_patch_rect.region_rect = nine_patch_region_rect
	_nine_patch_rect.patch_margin_left = nine_patch_patch_left
	_nine_patch_rect.patch_margin_right = nine_patch_patch_right
	_nine_patch_rect.patch_margin_top = nine_patch_patch_top
	_nine_patch_rect.patch_margin_bottom = nine_patch_patch_bottom
	_nine_patch_rect.axis_stretch_horizontal = nine_patch_axis_stretch_horizontal
	_nine_patch_rect.axis_stretch_vertical = nine_patch_axis_stretch_vertical


func _draw() -> void:
	if _shape == null:
		return
	
	if _shape is CircleShape2D:
		var c: CircleShape2D = _shape
		draw_circle(Vector2.ZERO, c.radius, color)
	elif _shape is RectangleShape2D:
		var r: RectangleShape2D = _shape
		var rect = Rect2(-r.extents, r.extents * 2.0)
		draw_rect(rect, color, true)
	elif _shape is SegmentShape2D:
		var s: SegmentShape2D = _shape
		draw_line(s.a, s.b, color, 3.0)
	elif _shape is SeparationRayShape2D:
		var r: SeparationRayShape2D = _shape
		draw_line(Vector2.ZERO, Vector2.DOWN * r.length, color, 3.0)
	elif _shape is WorldBoundaryShape2D:
		var l: WorldBoundaryShape2D = _shape
		var angle = l.normal.angle() + .5 * PI
		var normal_length = l.normal.length()
		var left_pt = (Vector2.LEFT * 100.0 * normal_length + Vector2.UP * l.distance).rotated(angle)
		var right_pt = (Vector2.RIGHT * 100.0 * normal_length + Vector2.UP * l.distance).rotated(angle)
		draw_line(left_pt, right_pt, color, 3.0)


func _on_draw() -> void:
	_process_parent_shape()
	queue_redraw()


func _make_prop(prop_name: String, type: int, usage: int = PROPERTY_USAGE_DEFAULT, hint = []) -> Dictionary:
	var prop = {
		name = prop_name,
		type = type,
		usage = usage
	}
	if hint:
		if hint is String:
			prop.hint_string = hint
		elif hint is Array and hint.size() > 1:
			prop.hint = PROPERTY_HINT_RANGE
			if hint[0] is int and hint[1] is int:
				prop.hint_string = "%d,%d" % hint
			else:
				prop.hint_string = "%f,%f" % hint
		elif hint is Dictionary:
			prop.hint = PROPERTY_HINT_ENUM
			var temp = ""
			for k in hint.keys():
				if !temp.is_empty():
					temp += ","
				temp += "%s:%s" % [k, str(hint[k])]
			prop.hint_string = temp
		else:
			prop.hint_string = str(hint)
	return  prop


func _get_property_list():
	var props := []
	props.append(_make_prop("ShapeDraw2D", TYPE_NIL, PROPERTY_USAGE_CATEGORY))
	props.append(_make_prop("color", TYPE_COLOR))
	props.append(_make_prop("texture", TYPE_OBJECT))
	
	props.append(_make_prop("Non-Rectangle Shape3D", TYPE_NIL, PROPERTY_USAGE_GROUP, "non_rect"))
	props.append(_make_prop("non_rect_texture_offset", TYPE_VECTOR2))
	props.append(_make_prop("non_rect_texture_scale", TYPE_VECTOR2))

	props.append(_make_prop("Rectangle Shape3D", TYPE_NIL, PROPERTY_USAGE_GROUP, "nine_patch"))
	props.append(_make_prop("nine_patch_draw_center", TYPE_BOOL))
	props.append(_make_prop("nine_patch_region_rect", TYPE_RECT2))
	props.append(_make_prop("nine_patch_patch_left", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_right", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_top", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_bottom", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_axis_stretch_horizontal", TYPE_INT, PROPERTY_USAGE_DEFAULT, AxisStretchMode))
	props.append(_make_prop("nine_patch_axis_stretch_vertical", TYPE_INT, PROPERTY_USAGE_DEFAULT, AxisStretchMode))

	return props
	
