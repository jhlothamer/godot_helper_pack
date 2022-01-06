tool
extends CollisionShape2D

var use_global_color := true setget _set_use_global_color
var color: Color = Color(1.0,1.0,1.0,1.0) setget _set_color


var texture: Texture setget _set_texture

# applies to rectangle shape - for nine patch
var nine_patch_draw_center := true setget _set_draw_center
var nine_patch_region_rect: Rect2 setget _set_region_rect
var nine_patch_patch_left := 0 setget _set_patch_left
var nine_patch_patch_right := 0 setget _set_patch_right
var nine_patch_patch_top := 0 setget _set_patch_top
var nine_patch_patch_bottom := 0 setget _set_patch_bottom
var nine_patch_axis_stretch_horizontal: int setget _set_axis_stretch_horizontal
var nine_patch_axis_stretch_vertical: int setget _set_axis_stretch_vertical

onready var _shapedraw: ShapeDraw2D = $ShapeDraw2D

func _set_color(value) -> void:
	if use_global_color:
		return
	color = value
	if _shapedraw != null:
		_shapedraw.color = value


func _set_use_global_color(value: bool) -> void:
	if !use_global_color and value:
		_set_color(GodotHelperPackSettings.get_global_blocking_color())
	use_global_color = value
	

func _set_texture(value: Texture) -> void:
	texture = value
	if _shapedraw:
		_shapedraw.texture = value


func _set_draw_center(value: bool) -> void:
	nine_patch_draw_center =  value
	if _shapedraw:
		_shapedraw.nine_patch_draw_center = value


func _set_region_rect(value: Rect2) -> void:
	nine_patch_region_rect =  value
	if _shapedraw:
		_shapedraw.nine_patch_region_rect = value


func _set_patch_left(value: int) -> void:
	nine_patch_patch_left =  value
	if _shapedraw:
		_shapedraw.nine_patch_patch_left = value


func _set_patch_right(value: int) -> void:
	nine_patch_patch_right =  value
	if _shapedraw:
		_shapedraw.nine_patch_patch_right = value


func _set_patch_top(value: int) -> void:
	nine_patch_patch_top =  value
	if _shapedraw:
		_shapedraw.nine_patch_patch_top = value


func _set_patch_bottom(value: int) -> void:
	nine_patch_patch_bottom =  value
	if _shapedraw:
		_shapedraw.nine_patch_patch_bottom = value


func _set_axis_stretch_horizontal(value: int) -> void:
	nine_patch_axis_stretch_horizontal =  value
	if _shapedraw:
		_shapedraw.nine_patch_axis_stretch_horizontal = value


func _set_axis_stretch_vertical(value: int) -> void:
	nine_patch_axis_stretch_vertical =  value
	if _shapedraw:
		_shapedraw.nine_patch_axis_stretch_vertical = value


func _ready():
	shape = shape.duplicate()
	if use_global_color:
		color = GodotHelperPackSettings.get_global_blocking_color()
	
	_shapedraw.color = color
	_shapedraw.texture = texture
	_shapedraw.nine_patch_draw_center = nine_patch_draw_center
	_shapedraw.nine_patch_region_rect = nine_patch_region_rect
	_shapedraw.nine_patch_patch_left = nine_patch_patch_left
	_shapedraw.nine_patch_patch_right = nine_patch_patch_right
	_shapedraw.nine_patch_patch_top = nine_patch_patch_top
	_shapedraw.nine_patch_patch_bottom = nine_patch_patch_bottom
	_shapedraw.nine_patch_axis_stretch_horizontal = nine_patch_axis_stretch_horizontal
	_shapedraw.nine_patch_axis_stretch_vertical = nine_patch_axis_stretch_vertical	
	
	if Engine.editor_hint:
		return
	
	var parent = get_parent()
	if parent is StaticBody2D or \
		parent is RigidBody2D or  \
		parent is Area2D or \
		parent is KinematicBody2D:
			return
	
	yield(parent,"ready")
	
	var sb := StaticBody2D.new()
	parent.add_child(sb)
	parent.remove_child(self)
	sb.add_child(self)


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
	props.append(_make_prop("BlockingBlock2D", TYPE_NIL, PROPERTY_USAGE_CATEGORY))
	props.append(_make_prop("use_global_color", TYPE_COLOR))
	props.append(_make_prop("color", TYPE_COLOR))
	props.append(_make_prop("texture", TYPE_OBJECT))

	props.append(_make_prop("Rectangle Shape", TYPE_NIL, PROPERTY_USAGE_GROUP, "nine_patch"))
	props.append(_make_prop("nine_patch_draw_center", TYPE_BOOL))
	props.append(_make_prop("nine_patch_region_rect", TYPE_RECT2))
	props.append(_make_prop("nine_patch_patch_left", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_right", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_top", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_patch_bottom", TYPE_INT, PROPERTY_USAGE_DEFAULT, [0, 16384]))
	props.append(_make_prop("nine_patch_axis_stretch_horizontal", TYPE_INT, PROPERTY_USAGE_DEFAULT, ShapeDraw2D.AxisStretchMode))
	props.append(_make_prop("nine_patch_axis_stretch_vertical", TYPE_INT, PROPERTY_USAGE_DEFAULT, ShapeDraw2D.AxisStretchMode))

	return props


func update_from_global_blocking_color(updated_color: Color) -> void:
	if !use_global_color:
		return
	color = updated_color
	_shapedraw.color = color


