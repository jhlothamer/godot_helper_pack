tool
class_name ShapeDraw2D
extends Node2D

export var color: Color = Color(1.0,1.0,1.0,1.0) setget set_color

var shape: Shape2D
var polygon: Polygon2D

func set_color(value):
	color = value
	if polygon != null:
		polygon.color = value
	else:
		update()


func _ready():
	process_parent_shape()
	if Engine.editor_hint:
		get_parent().connect("draw", self, "_on_draw")


func process_parent_shape():
	var parent = get_parent()
	if parent is CollisionShape2D:
		if parent.shape is ConvexPolygonShape2D:
			create_polygon_2d(parent.shape.points)
		elif parent.shape is ConcavePolygonShape2D:
			create_polygon_2d(parent.shape.segments)
		elif parent.shape is CapsuleShape2D:
			var shape_polygon = Shape2DUtil.make_polygon_from_shape(parent.shape)
			create_polygon_2d(shape_polygon)
		else:
			shape = parent.shape
			if polygon:
				polygon.queue_free()
				polygon = null
	elif parent is CollisionPolygon2D:
		create_polygon_2d(parent.polygon)
	else:
		push_error("Parent of ShapeDraw must be CollisionShape2D or CollisionPolygon2D.")
	

func create_polygon_2d(p: PoolVector2Array):
	if polygon == null:
		polygon = Polygon2D.new()
		add_child(polygon)
	polygon.polygon = PoolVector2Array(p)
	polygon.color = color


func _draw():
	if shape == null:
		return
	
	if shape is CircleShape2D:
		var c: CircleShape2D = shape
		draw_circle(Vector2.ZERO, c.radius, color)
	elif shape is RectangleShape2D:
		var r: RectangleShape2D = shape
		var rect = Rect2(-r.extents, r.extents * 2.0)
		draw_rect(rect, color, true)
	elif shape is SegmentShape2D:
		var s: SegmentShape2D = shape
		draw_line(s.a, s.b, color, 3.0)
	elif shape is RayShape2D:
		var r: RayShape2D = shape
		draw_line(Vector2.ZERO, Vector2.DOWN * r.length, color, 3.0)
	elif shape is LineShape2D:
		var l: LineShape2D = shape
		var angle = l.normal.angle() + .5 * PI
		var normal_length = l.normal.length()
		var left_pt = (Vector2.LEFT * 100.0 * normal_length + Vector2.UP * l.d).rotated(angle)
		var right_pt = (Vector2.RIGHT * 100.0 * normal_length + Vector2.UP * l.d).rotated(angle)
		draw_line(left_pt, right_pt, color, 3.0)

func _on_draw():
	process_parent_shape()
	update()
