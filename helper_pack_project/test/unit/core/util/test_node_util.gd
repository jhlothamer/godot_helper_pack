extends "res://addons/gut/test.gd"


func test_remove_children_no_free():
	var parent_node := Node.new()
	var children := []
	for i in range(10):
		var child_node := Node.new()
		children.append(child_node)
		child_node.name = str(i)
		parent_node.add_child(child_node)
	assert_eq(10, parent_node.get_child_count())
	NodeUtil.remove_children(parent_node)
	assert_eq(0, parent_node.get_child_count())
	for child in children:
		assert_false(child.is_queued_for_deletion())


func test_remove_children_with_free():
	var parent_node := Node.new()
	var children := []
	for i in range(10):
		var child_node := Node.new()
		children.append(child_node)
		child_node.name = str(i)
		parent_node.add_child(child_node)
	assert_eq(10, parent_node.get_child_count())
	NodeUtil.remove_children(parent_node, true)
	assert_eq(0, parent_node.get_child_count())
	for child in children:
		assert_true(child.is_queued_for_deletion())
