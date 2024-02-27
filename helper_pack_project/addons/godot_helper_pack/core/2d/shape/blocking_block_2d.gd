## The BlockingBlock2D node is designed to make level blocking for 2D scenes
## a bit simpler. It takes the place of using a StaticBody2D and
## multiple CollisionShape2D nodes.
## Please wiki page for details:
## https://github.com/jhlothamer/godot_helper_pack/wiki/BlockingBlock2D

@tool
extends CollisionShape2D

## If true, color is dictated by the Blocking Global Color.
## Otherwise, the color property determines the color.
@export var use_global_color := true :
	set(mod_value):
		if !use_global_color and mod_value:
			color = GodotHelperPackSettings.get_global_blocking_color()
		use_global_color = mod_value
## Color of the block if Use Global Color is set to false.
@export var color: Color = Color(1.0,1.0,1.0,1.0) :
	set(mod_value):
		color = mod_value
		if _shapedraw != null:
			_shapedraw.color = mod_value
## Texture for the shape.
@export var texture: Texture2D :
	set(mod_value):
		texture = mod_value
		if _shapedraw:
			_shapedraw.texture = mod_value

# applies to all but rect
@export_group("Non-Rectangle Shape2D", "non_rect")
## Offset for texture applied to polygons.  If zero, texture
## is centered in the polygon.
@export var non_rect_texture_offset := Vector2.ZERO :
	set(mod_value):
		non_rect_texture_offset = mod_value
		if _shapedraw:
			_shapedraw.non_rect_texture_offset = mod_value
## Scale applied to the texture of the polygon.
@export var non_rect_texture_scale := Vector2.ONE :
	set(mod_value):
		non_rect_texture_scale = mod_value
		if _shapedraw:
			_shapedraw.non_rect_texture_scale = mod_value


# applies to rectangle shape - for nine patch
@export_group("Rectangle Shape2D", "nine_patch")
## If true, the center of the rectangle is drawn.  Otherwise
## you're left with just the border determined by the 
## left, right, top, bottom property values
@export var nine_patch_draw_center := true :
	set(mod_value):
		nine_patch_draw_center = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_draw_center = mod_value
## If set, only the part of the texture determined by the region
## will be used.
@export var nine_patch_region_rect: Rect2 :
	set(mod_value):
		nine_patch_region_rect = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_region_rect = mod_value
## The width of the 9-slice's left column.
@export var nine_patch_patch_left := 0 :
	set(mod_value):
		nine_patch_patch_left = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_left = mod_value
## The width of the 9-slice's right column.
@export var nine_patch_patch_right := 0 :
	set(mod_value):
		nine_patch_patch_right = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_right = mod_value
## The height of the 9-slice's top row.
@export var nine_patch_patch_top := 0 :
	set(mod_value):
		nine_patch_patch_top = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_top = mod_value
## The height of the 9-slice's bottom row.
@export var nine_patch_patch_bottom := 0 :
	set(mod_value):
		nine_patch_patch_bottom = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_bottom = mod_value
## mode to stretch, tile or tile fit horizontally
var nine_patch_axis_stretch_horizontal: NinePatchRect.AxisStretchMode :
	set(mod_value):
		nine_patch_axis_stretch_horizontal = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_axis_stretch_horizontal = mod_value
## mode to stretch, tile or tile fit vertically
@export var nine_patch_axis_stretch_vertical: NinePatchRect.AxisStretchMode :
	set(mod_value):
		nine_patch_axis_stretch_vertical = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_axis_stretch_vertical = mod_value


@onready var _shapedraw: ShapeDraw2D = $ShapeDraw2D


func _ready():
	if use_global_color:
		color = GodotHelperPackSettings.get_global_blocking_color()
	
	# pass property values along to shape draw
	_shapedraw.color = color
	_shapedraw.texture = texture
	_shapedraw.non_rect_texture_offset = non_rect_texture_offset
	_shapedraw.non_rect_texture_scale = non_rect_texture_scale
	_shapedraw.nine_patch_draw_center = nine_patch_draw_center
	_shapedraw.nine_patch_region_rect = nine_patch_region_rect
	_shapedraw.nine_patch_patch_left = nine_patch_patch_left
	_shapedraw.nine_patch_patch_right = nine_patch_patch_right
	_shapedraw.nine_patch_patch_top = nine_patch_patch_top
	_shapedraw.nine_patch_patch_bottom = nine_patch_patch_bottom
	_shapedraw.nine_patch_axis_stretch_horizontal = nine_patch_axis_stretch_horizontal
	_shapedraw.nine_patch_axis_stretch_vertical = nine_patch_axis_stretch_vertical	
	
	if Engine.is_editor_hint():
		shape = shape.duplicate()
		return
	
	var parent = get_parent()
	if parent is CollisionObject2D:
			return
	
	await parent.ready
	
	var sb := StaticBody2D.new()
	parent.add_child(sb)
	parent.remove_child(self)
	sb.add_child(self)


func update_from_global_blocking_color(updated_color: Color) -> void:
	if !use_global_color:
		return
	color = updated_color
	_shapedraw.color = color


