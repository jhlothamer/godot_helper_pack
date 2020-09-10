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
		if parent.shape is ConcavePolygonShape2D:
			create_polygon_2d(parent.shape.segments)
		else:
			shape = parent.shape
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
	elif shape is CapsuleShape2D:
		var c: CapsuleShape2D = shape
		draw_circle(Vector2(0, c.height * .5), c.radius, color)
		draw_circle(Vector2(0, -c.height * .5), c.radius, color)
		var rect = Rect2(-1*Vector2(c.radius, c.height*.5), Vector2(c.radius*2, c.height))
		draw_rect(rect, color)

func _on_draw():
	process_parent_shape()
	update()
