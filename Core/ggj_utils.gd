class_name Utils
extends Node

static func get_player_from(child_node : Node) -> Player:
	if not child_node:
		return null
	if not child_node.is_inside_tree():
		return null
	var root := child_node.get_tree().root
	while child_node and root:
		if child_node is Player:
			return child_node
		child_node = child_node.get_parent()
	return null
