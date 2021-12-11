tool
extends CollisionShape2D

export var use_global_color := true setget _set_use_global_color
export var color: Color = Color(1.0,1.0,1.0,1.0) setget _set_color

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
	


func _ready():
	shape = shape.duplicate()
	if use_global_color:
		color = GodotHelperPackSettings.get_global_blocking_color()
		_shapedraw.color = color
	else:
		_set_color(color)
	
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


func update_from_global_blocking_color(updated_color: Color) -> void:
	if !use_global_color:
		return
	color = updated_color
	_shapedraw.color = color


