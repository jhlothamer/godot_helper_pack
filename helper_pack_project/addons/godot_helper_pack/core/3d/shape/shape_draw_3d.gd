@tool
class_name ShapeDraw3D
extends Node3D


@export var color: Color = Color.WHITE :
	set(mod_value):
		color = mod_value
		if _material:
			_material.albedo_color = color


var _mesh_instance: MeshInstance3D
var _material := StandardMaterial3D.new()
var _parent_collision_shape: CollisionShape3D


func _ready():
	_parent_collision_shape = get_parent()
	update_configuration_warnings()
	if !_parent_collision_shape:
		return
	_parent_collision_shape.shape.changed.connect(_on_parent_shape_changed)

	for c in get_children():
		if c is MeshInstance3D:
			_mesh_instance = c
			_mesh_instance.mesh = _mesh_instance.mesh.duplicate()
			_mesh_instance.mesh.material = _material

			break
	
	if !_mesh_instance:
		_mesh_instance = MeshInstance3D.new()
		add_child(_mesh_instance)

	self.color = color
	
	_process_parent_shape()


func _on_parent_shape_changed():
	_process_parent_shape()


func _process_parent_shape():
	if !_parent_collision_shape:
		print("ShapeDraw3D: no parent collision shape")
		return
	if !_parent_collision_shape.shape:
		print("ShapeDraw3D: parent collision shape has no shape")
		return
	# must wait a bit for shape change to take affect
	await get_tree().create_timer(.01).timeout
	_update_mesh(_parent_collision_shape.shape)


func _update_mesh(shape: Shape3D):
	if shape is BoxShape3D:
		var bs := shape as BoxShape3D
		var cm: BoxMesh
		if _mesh_instance.mesh is BoxMesh:
			cm = _mesh_instance.mesh
		else:
			cm = BoxMesh.new()
			_mesh_instance.mesh = cm
			cm.material = _material
		cm.size = bs.extents * 2
	elif shape is CapsuleShape3D:
		var cs := shape as CapsuleShape3D
		var cm: CapsuleMesh
		if _mesh_instance.mesh is CapsuleMesh:
			cm = _mesh_instance.mesh
		else:
			cm = CapsuleMesh.new()
			_mesh_instance.mesh = cm
			cm.material = _material
		cm.height = cs.height
		cm.radius = cs.radius
	elif shape is CylinderShape3D:
		var cs := shape as CylinderShape3D
		var cm: CylinderMesh
		if _mesh_instance.mesh is CylinderMesh:
			cm = _mesh_instance.mesh
		else:
			cm = CylinderMesh.new()
			_mesh_instance.mesh = cm
			cm.material = _material
		cm.bottom_radius = cs.radius
		cm.top_radius = cs.radius
		cm.height = cs.height
	elif shape is SphereShape3D:
		var ss := shape as SphereShape3D
		var sm: SphereMesh
		if _mesh_instance.mesh is SphereMesh:
			sm = _mesh_instance.mesh
		else:
			sm = SphereMesh.new()
			_mesh_instance.mesh = sm
			sm.material = _material
		sm.radius = ss.radius
		sm.height = ss.radius * 2.0
#	elif shape is ConcavePolygonShape3D:
#		var cps := shape as ConcavePolygonShape3D
#	elif shape is ConvexPolygonShape3D:
#		var cps := shape as ConvexPolygonShape3D


func _get_configuration_warnings():
	if !_parent_collision_shape is CollisionShape3D:
		return "Cannot update shape in editor unless parent is CollisionShape3D"
	return ""
