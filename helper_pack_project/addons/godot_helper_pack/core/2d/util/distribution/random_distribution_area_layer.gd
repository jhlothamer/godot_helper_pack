tool
class_name RandomDistributionAreaLayer, "random_distribution_area_layer.svg"
extends Node


# the min distance between spawned objects
export (float, 1.0, 10000.0) var distribution_radius : float = 128.0
# The area the objects take up - used for multiple layers to reject overlapping objects
export (float, 1.0, 10000.0) var object_radius : float = 64.0
# node cloned objects are added to - this cannot be the rand distribution areay itself
export var distributed_clone_parent: NodePath
export var discarded_point_clone_parent: NodePath
# Array of scenes to clone - can add as children to this node instead
export (Array, PackedScene) var scenes_to_distribute: Array = []
export var enabled := true
export var layer_exclusion_polygon_node_group := "layer_exclusion_polygon"



func get_clone_parent() -> Node:
	if distributed_clone_parent == null or str(distributed_clone_parent) == "":
		push_error("RandomDistributionAreaLayer: no distributed clone parent set (%s)" % get_path())
		return null
	return get_node(distributed_clone_parent)


func get_discarded_point_clone_parent() -> Node:
	if discarded_point_clone_parent == null or str(discarded_point_clone_parent) == "":
		return null
	print("discarded_point_clone_parent = " + str(discarded_point_clone_parent))
	return get_node(discarded_point_clone_parent)

func get_items_to_distribute() -> Array:
	var items := []
	for c in get_children():
		if c.has_method("_i_am_a_random_distribution_area_layer"):
			continue
		items.append(c)
	items.append_array(scenes_to_distribute)
	if items.size() < 1:
		push_error("RandomDistributionAreaLayer: no items to distribute (%s)" % get_path())
	return items

func _enter_tree():
	update_configuration_warning()


func _get_configuration_warning() -> String:
	var parent = get_parent()
	if parent != null and !parent is RandomDistributionArea:
		return "Parent must be a RandomDistributionArea node"
	return ""

# Can't refer to this class from RandomDistributionArea due to circular
# reference.  This function allows RandomDistributionArea to know it has a
# reference to a RandomDistributionAreaLayer node.
func _i_am_a_random_distribution_area_layer():
	pass
