##The ShapeDraw2D node draws the shape of any CollisionShape2D or CollisionPolygon2D
## that it's a child of. It does this both in the editor as well as when your
## game is running. It is meant to help with prototyping when you want to
## see your collision shapes and you don't yet have art for your game.
## Please see wiki page for details:
## https://github.com/jhlothamer/godot_helper_pack/wiki/ShapeDraw2D
@tool
class_name ShapeDraw2D
extends Node2D

enum AxisStretchMode {
	STRETCH,
	TILE,
	TILE_FIT
}

## Color of shape if texture not set.
@export var color: Color = Color(1.0,1.0,1.0,1.0) :
	set(mod_value):
		color = mod_value
		if _polygon != null and !texture:
			_polygon.color = mod_value
		else:
			queue_redraw()
## Texture for the shape.
@export var texture: Texture2D :
	set(mod_value):
		texture = mod_value
		_process_parent_shape()
		queue_redraw()

# applies to all but rect
@export_group("Non-Rectangle Shape2D", "non_rect")
## Offset for texture applied to polygons.  If zero, texture
## is centered in the polygon.
@export var non_rect_texture_offset := Vector2.ZERO :
	set(mod_value):
		non_rect_texture_offset = mod_value
		if _polygon:
			_polygon.texture_scale = Vector2.ONE / non_rect_texture_scale
## Scale applied to the texture of the polygon.
@export var non_rect_texture_scale := Vector2.ONE :
	set(mod_value):
		non_rect_texture_scale = mod_value
		if _polygon:
			_polygon.texture_scale = Vector2.ONE / non_rect_texture_scale
			_polygon.texture_offset = _polygon_midpt + (texture.get_size() / 2.0 - non_rect_texture_offset) * non_rect_texture_scale


# applies to rectangle shape - for nine patch
@export_group("Rectangle Shape2D", "nine_patch")
## If true, the center of the rectangle is drawn.  Otherwise
## you're left with just the border determined by the 
## left, right, top, bottom property values
@export var nine_patch_draw_center := true :
	set(mod_value):
		nine_patch_draw_center = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.draw_center = mod_value
## If set, only the part of the texture determined by the region
## will be used.
@export var nine_patch_region_rect: Rect2 :
	set(mod_value):
		nine_patch_region_rect = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.region_rect = mod_value
## The width of the 9-slice's left column.
@export var nine_patch_patch_left := 0 :
	set(mod_value):
		nine_patch_patch_left = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_left = mod_value
## The width of the 9-slice's right column.
@export var nine_patch_patch_right := 0 :
	set(mod_value):
		nine_patch_patch_right = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_right = mod_value
## The height of the 9-slice's top row.
@export var nine_patch_patch_top := 0 :
	set(mod_value):
		nine_patch_patch_top = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_top = mod_value
## The height of the 9-slice's bottom row.
@export var nine_patch_patch_bottom := 0 :
	set(mod_value):
		nine_patch_patch_bottom = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.patch_margin_bottom = mod_value
## mode to stretch, tile or tile fit horizontally
@export var nine_patch_axis_stretch_horizontal: NinePatchRect.AxisStretchMode :
	set(mod_value):
		nine_patch_axis_stretch_horizontal = mod_value
		if _nine_patch_rect:
			_nine_patch_rect.axis_stretch_horizontal = mod_value
## mode to stretch, tile or tile fit vertically
@export var nine_patch_axis_stretch_vertical: NinePatchRect.AxisStretchMode :
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

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	var parent = get_parent()
	if !parent is CollisionShape2D and !parent is CollisionPolygon2D:
		warnings = ['ShapeDraw2D must be child of CollisionShape2D or CollisionPolygon2D']
	return warnings


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
		if !_polygon_midpt.is_finite():
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
