class_name Utils
extends Node

#region Names

const group_damageable := &"Damageable"
const group_collectible := &"Collectible"

const node_health := &"Health"
const nodepath_health := "$Health"

#endregion

static func get_player_from(child_node : Node) -> Player:
	if not child_node:
		return null
	if not child_node.is_inside_tree():
		return null
	while child_node:
		if child_node is Player:
			return child_node
		child_node = child_node.get_parent()
	return null

#region Damage

static func get_damageable_from(child_node : Node) -> Node:
	if not child_node:
		return null
	while child_node:
		if child_node.is_in_group(group_damageable):
			return child_node
		child_node = child_node.get_parent()
	return null

static func get_health_from(child_node : Node) -> Attribute:
	var damageable := get_damageable_from(child_node)
	if not damageable:
		push_warning("Node " + str(child_node) + " is not a child of a Damageable node!")
		return null
	var health := damageable.get_node(nodepath_health) as Attribute
	if not health:
		push_error("Health not found on Damageable node " + str(damageable))
		return null
	return health

static func deal_damage(target : Node, damage : float) -> bool:
	var health := get_health_from(target)
	if not health:
		return false
	if health.value <= 0.0:
		return false
	health.add_instant(-damage)
	return true

#endregion
