tool
class_name Circle2D
extends Position2D

export (float, .1, 10000.0) var radius: float = 10.0 setget set_radius
export var color: Color = Color.white setget set_color
export var stroke_color := Color.transparent setget set_stroke_color
export (float, 1.0, 20.0) var stroke_width := 2.0 setget set_stroke_width

func set_color(value):
	color = value
	update()

func set_radius(value):
	radius = value
	update()

func set_stroke_color(value):
	stroke_color = value
	update()

func set_stroke_width(value):
	stroke_width = value
	update()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
	if stroke_color != Color.transparent:
		draw_arc(Vector2.ZERO, radius - (stroke_width/2.0), 0.0, 2*PI, 200,
			stroke_color, stroke_width, true)
