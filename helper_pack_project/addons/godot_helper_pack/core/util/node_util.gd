class_name NodeUtil
extends Node
"""
Collection of node utility functions.
"""


# removes all children from a node, optionally freeing children
static func remove_children(node: Node, free_children: bool = false) -> void:
	for child in node.get_children():
		node.remove_child(child)
		if free_children:
			child.queue_free()
