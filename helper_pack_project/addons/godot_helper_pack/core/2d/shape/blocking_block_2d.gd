@tool
extends CollisionShape2D

var use_global_color := true :
	set(mod_value):
		if !use_global_color and mod_value:
			color = GodotHelperPackSettings.get_global_blocking_color()
		use_global_color = mod_value
var color: Color = Color(1.0,1.0,1.0,1.0) :
	set(mod_value):
		color = mod_value
		if _shapedraw != null:
			_shapedraw.color = mod_value
var texture: Texture2D :
	set(mod_value):
		texture = mod_value
		if _shapedraw:
			_shapedraw.texture = mod_value

# applies to all but rect
var non_rect_texture_offset := Vector2.ZERO :
	set(mod_value):
		non_rect_texture_offset = mod_value
		if _shapedraw:
			_shapedraw.non_rect_texture_offset = mod_value
var non_rect_texture_scale := Vector2.ONE :
	set(mod_value):
		non_rect_texture_scale = mod_value
		if _shapedraw:
			_shapedraw.non_rect_texture_scale = mod_value
# applies to rectangle shape - for nine patch
var nine_patch_draw_center := true :
	set(mod_value):
		nine_patch_draw_center = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_draw_center = mod_value
var nine_patch_region_rect: Rect2 :
	set(mod_value):
		nine_patch_region_rect = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_region_rect = mod_value
var nine_patch_patch_left := 0 :
	set(mod_value):
		nine_patch_patch_left = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_left = mod_value
var nine_patch_patch_right := 0 :
	set(mod_value):
		nine_patch_patch_right = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_right = mod_value
var nine_patch_patch_top := 0 :
	set(mod_value):
		nine_patch_patch_top = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_top = mod_value
var nine_patch_patch_bottom := 0 :
	set(mod_value):
		nine_patch_patch_bottom = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_patch_bottom = mod_value
var nine_patch_axis_stretch_horizontal: NinePatchRect.AxisStretchMode :
	set(mod_value):
		nine_patch_axis_stretch_horizontal = mod_value
		if _shapedraw:
			_shapedraw.nine_patch_axis_stretch_horizontal = mod_value
var nine_patch_axis_stretch_vertical: NinePatchRect.AxisStretchMode :
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


func _make_prop(prop_name: String, type: int, usage: int = PROPERTY_USAGE_DEFAULT, hint: int = -1, hint_string_data = []) -> Dictionary:
	var prop = {
		name = prop_name,
		type = type,
		usage = usage
	}
	if hint > -1:
		prop.hint = hint
	if hint_string_data:
		if hint_string_data is String:
			prop.hint_string = hint_string_data
		elif hint_string_data is Array and hint_string_data.size() > 1:
			if hint < 0:
				prop.hint = PROPERTY_HINT_RANGE
			if hint_string_data[0] is int and hint_string_data[1] is int:
				prop.hint_string = "%d,%d" % hint_string_data
			else:
				prop.hint_string = "%f,%f" % hint_string_data
		elif hint_string_data is Dictionary:
			if hint < 0:
				prop.hint = PROPERTY_HINT_ENUM
			var temp = ""
			for k in hint_string_data.keys():
				if !temp.is_empty():
					temp += ","
				temp += "%s:%s" % [k, str(hint_string_data[k])]
			prop.hint_string = temp
		
	return  prop


func _get_property_list():
	var props := []
	props.append(_make_prop("BlockingBlock2D", TYPE_NIL, PROPERTY_USAGE_CATEGORY))
	props.append(_make_prop("use_global_color", TYPE_BOOL))
	props.append(_make_prop("color", TYPE_COLOR))
	props.append(_make_prop("texture", TYPE_OBJECT, PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE, PROPERTY_HINT_RESOURCE_TYPE, "Texture2D"))
	
	props.append(_make_prop("Non-Rectangle Shape3D", TYPE_NIL, PROPERTY_USAGE_GROUP, -1, "non_rect"))
	props.append(_make_prop("non_rect_texture_offset", TYPE_VECTOR2))
	props.append(_make_prop("non_rect_texture_scale", TYPE_VECTOR2))


	props.append(_make_prop("Rectangle Shape2D", TYPE_NIL, PROPERTY_USAGE_GROUP, -1, "nine_patch"))
	props.append(_make_prop("nine_patch_draw_center", TYPE_BOOL))
	props.append(_make_prop("nine_patch_region_rect", TYPE_RECT2))
	props.append(_make_prop("nine_patch_patch_left", TYPE_INT, PROPERTY_USAGE_DEFAULT, -1, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_right", TYPE_INT, PROPERTY_USAGE_DEFAULT, -1, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_top", TYPE_INT, PROPERTY_USAGE_DEFAULT, -1, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_bottom", TYPE_INT, PROPERTY_USAGE_DEFAULT, -1, [0, 16384]))
	props.append(_make_prop("nine_patch_axis_stretch_horizontal", TYPE_INT, PROPERTY_USAGE_DEFAULT, -1, ShapeDraw2D.AxisStretchMode))
	props.append(_make_prop("nine_patch_axis_stretch_vertical", TYPE_INT, PROPERTY_USAGE_DEFAULT, -1, ShapeDraw2D.AxisStretchMode))

	return props


func update_from_global_blocking_color(updated_color: Color) -> void:
	if !use_global_color:
		return
	color = updated_color
	_shapedraw.color = color


