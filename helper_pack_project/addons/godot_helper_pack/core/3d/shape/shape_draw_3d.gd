tool
class_name ShapeDraw3D
extends Spatial

export var color: Color = Color.white setget _set_color


var _mesh_instance: MeshInstance # := MeshInstance.new()
var _material := SpatialMaterial.new()
var _parent_collision_shape: CollisionShape

func _set_color(value):
	color = value
	if _material:
		_material.albedo_color = color

func _ready():
	_parent_collision_shape = get_parent()
	update_configuration_warning()
	if !_parent_collision_shape:
		#printerr("ShapeDraw3D: Parent must be CollisionShapeEx")
		push_warning("Warning!")
		return
	_parent_collision_shape.connect("shape_changed", self, "_on_parent_shape_changed", [])

	for c in get_children():
		if c is MeshInstance:
			_mesh_instance = c
			_mesh_instance.mesh = _mesh_instance.mesh.duplicate()
			_mesh_instance.mesh.material = _material

			break
	
	if !_mesh_instance:
		_mesh_instance = MeshInstance.new()
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
	yield(get_tree().create_timer(.01), "timeout")
	_update_mesh(_parent_collision_shape.shape)


func _update_mesh(shape: Shape):
	if shape is BoxShape:
		var bs := shape as BoxShape
		var cm: CubeMesh
		if _mesh_instance.mesh is CubeMesh:
			cm = _mesh_instance.mesh
		else:
			cm = CubeMesh.new()
			_mesh_instance.mesh = cm
			cm.material = _material
		cm.size = bs.extents * 2
	elif shape is CapsuleShape:
		var cs := shape as CapsuleShape
		var cm: CapsuleMesh
		if _mesh_instance.mesh is CapsuleMesh:
			cm = _mesh_instance.mesh
		else:
			cm = CapsuleMesh.new()
			_mesh_instance.mesh = cm
			cm.material = _material
		cm.mid_height = cs.height
		cm.radius = cs.radius
	elif shape is CylinderShape:
		var cs := shape as CylinderShape
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
	elif shape is SphereShape:
		var ss := shape as SphereShape
		var sm: SphereMesh
		if _mesh_instance.mesh is SphereMesh:
			sm = _mesh_instance.mesh
		else:
			sm = SphereMesh.new()
			_mesh_instance.mesh = sm
			sm.material = _material
		sm.radius = ss.radius
		sm.height = ss.radius * 2.0
#	elif shape is ConcavePolygonShape:
#		var cps := shape as ConcavePolygonShape
#	elif shape is ConvexPolygonShape:
#		var cps := shape as ConvexPolygonShape


func _get_configuration_warning():
	if !_parent_collision_shape is CollisionShapeEx:
		return "Cannot update shape in editor unless parent is CollisionShapeEx"
	return ""
