tool
class_name ShapeDraw2D
extends Node2D

enum AxisStretchMode {
	STRETCH,
	TILE,
	TILE_FIT
}

var color: Color = Color(1.0,1.0,1.0,1.0) setget _set_color
var texture: Texture setget _set_texture

# applies to all but rect
var non_rect_texture_offset := Vector2.ZERO setget _set_non_rect_texture_offset
var non_rect_texture_scale := Vector2.ONE setget _set_non_rect_texture_scale

# applies to rectangle shape - for nine patch
var nine_patch_draw_center := true setget _set_draw_center
var nine_patch_region_rect: Rect2 setget _set_region_rect
var nine_patch_patch_left := 0 setget _set_patch_left
var nine_patch_patch_right := 0 setget _set_patch_right
var nine_patch_patch_top := 0 setget _set_patch_top
var nine_patch_patch_bottom := 0 setget _set_patch_bottom
var nine_patch_axis_stretch_horizontal: int setget _set_axis_stretch_horizontal
var nine_patch_axis_stretch_vertical: int setget _set_axis_stretch_vertical


var _shape: Shape2D
var _polygon: Polygon2D
var _polygon_midpt: Vector2
var _nine_patch_rect: NinePatchRect


func _set_color(value):
	color = value
	if _polygon != null and !texture:
		_polygon.color = value
	else:
		update()


func _set_texture(value: Texture) -> void:
	texture = value
	_process_parent_shape()
	update()


func _set_non_rect_texture_offset(value: Vector2) -> void:
	non_rect_texture_offset = value
	if texture and _polygon:
		_polygon.texture_offset = _polygon_midpt + (texture.get_size() / 2.0 - non_rect_texture_offset) * non_rect_texture_scale


func _set_non_rect_texture_scale(value: Vector2) -> void:
	non_rect_texture_scale = value
	if _polygon:
		_polygon.texture_scale = Vector2.ONE / non_rect_texture_scale
		_set_non_rect_texture_offset(non_rect_texture_offset)


func _set_draw_center(value: bool) -> void:
	nine_patch_draw_center =  value
	if _nine_patch_rect:
		_nine_patch_rect.draw_center = value


func _set_region_rect(value: Rect2) -> void:
	nine_patch_region_rect =  value
	if _nine_patch_rect:
		_nine_patch_rect.region_rect = value


func _set_patch_left(value: int) -> void:
	nine_patch_patch_left =  value
	if _nine_patch_rect:
		_nine_patch_rect.patch_margin_left = value


func _set_patch_right(value: int) -> void:
	nine_patch_patch_right =  value
	if _nine_patch_rect:
		_nine_patch_rect.patch_margin_right = value


func _set_patch_top(value: int) -> void:
	nine_patch_patch_top =  value
	if _nine_patch_rect:
		_nine_patch_rect.patch_margin_top = value


func _set_patch_bottom(value: int) -> void:
	nine_patch_patch_bottom =  value
	if _nine_patch_rect:
		_nine_patch_rect.patch_margin_bottom = value


func _set_axis_stretch_horizontal(value: int) -> void:
	nine_patch_axis_stretch_horizontal =  value
	if _nine_patch_rect:
		_nine_patch_rect.axis_stretch_horizontal = value


func _set_axis_stretch_vertical(value: int) -> void:
	nine_patch_axis_stretch_vertical =  value
	if _nine_patch_rect:
		_nine_patch_rect.axis_stretch_vertical = value


func _ready():
	_process_parent_shape()
	if Engine.editor_hint:
		get_parent().connect("draw", self, "_on_draw")


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
	

func _create_polygon_2d(p: PoolVector2Array) -> void:
	_shape = null
	if _nine_patch_rect:
		_nine_patch_rect.queue_free()
		_nine_patch_rect = null
	if !_polygon:
		_polygon = Polygon2D.new()
		add_child(_polygon)
	_polygon.polygon = PoolVector2Array(p)
	if !texture:
		_polygon.color = color
	_polygon.texture = texture
	if texture:
		_polygon_midpt = Vector2Util.midpoint_v2(p)
		if _polygon_midpt == Vector2.INF:
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
	
	_nine_patch_rect.rect_position = -rect_shape.extents
	_nine_patch_rect.rect_size = 2*rect_shape.extents
	
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
	elif _shape is RayShape2D:
		var r: RayShape2D = _shape
		draw_line(Vector2.ZERO, Vector2.DOWN * r.length, color, 3.0)
	elif _shape is LineShape2D:
		var l: LineShape2D = _shape
		var angle = l.normal.angle() + .5 * PI
		var normal_length = l.normal.length()
		var left_pt = (Vector2.LEFT * 100.0 * normal_length + Vector2.UP * l.d).rotated(angle)
		var right_pt = (Vector2.RIGHT * 100.0 * normal_length + Vector2.UP * l.d).rotated(angle)
		draw_line(left_pt, right_pt, color, 3.0)


func _on_draw() -> void:
	_process_parent_shape()
	update()


func _make_prop(name: String, type: int, usage: int = PROPERTY_USAGE_DEFAULT, hint = null) -> Dictionary:
	var prop = {
		name = name,
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
				if !temp.empty():
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
	
	props.append(_make_prop("Non-Rectangle Shape", TYPE_NIL, PROPERTY_USAGE_GROUP, "non_rect"))
	props.append(_make_prop("non_rect_texture_offset", TYPE_VECTOR2))
	props.append(_make_prop("non_rect_texture_scale", TYPE_VECTOR2))

	props.append(_make_prop("Rectangle Shape", TYPE_NIL, PROPERTY_USAGE_GROUP, "nine_patch"))
	props.append(_make_prop("nine_patch_draw_center", TYPE_BOOL))
	props.append(_make_prop("nine_patch_region_rect", TYPE_RECT2))
	props.append(_make_prop("nine_patch_patch_left", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_right", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_top", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_bottom", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_axis_stretch_horizontal", TYPE_INT, PROPERTY_USAGE_DEFAULT, AxisStretchMode))
	props.append(_make_prop("nine_patch_axis_stretch_vertical", TYPE_INT, PROPERTY_USAGE_DEFAULT, AxisStretchMode))

	return props
	
