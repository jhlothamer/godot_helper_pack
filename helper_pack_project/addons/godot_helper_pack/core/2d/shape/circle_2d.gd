## This node draw a circle.
@tool
class_name Circle2D
extends Marker2D

## Radius of circle.
@export_range(.1, 10000.0) var radius: float = 10.0 :
	set(mod_value):
		radius = mod_value
		queue_redraw()
## Fill color.
@export var color: Color = Color.WHITE :
	set(mod_value):
		color = mod_value
		queue_redraw()
## Stroke color.
@export var stroke_color := Color.TRANSPARENT :
	set(mod_value):
		stroke_color = mod_value
		queue_redraw()
## Stroke width.
@export_range(1.0, 20.0) var stroke_width := 2.0 :
	set(mod_value):
		stroke_width = mod_value
		queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
	if stroke_color != Color.TRANSPARENT:
		draw_arc(Vector2.ZERO, radius - (stroke_width/2.0), 0.0, 2*PI, 200,
			stroke_color, stroke_width, true)
