class_name Utils
extends Node

#region Names

const group_player := &"Player"
const group_damageable := &"Damageable"
const group_collectible := &"Collectible"
const group_infectable := &"Infectable"
const group_interactable := &"Interactable"

const nodepath_health := "Health"
const nodepath_infection := "Infection"

#endregion

static func find_parent_in_group(child_node : Node, group : StringName) -> Node:
	if not child_node:
		return null
	while child_node:
		if child_node.is_in_group(group):
			return child_node
		child_node = child_node.get_parent()
	return null

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
	return find_parent_in_group(child_node, group_damageable)

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

static func find_infection_component(target : Node) -> Infection:
	var infectable := find_parent_in_group(target, group_infectable)
	if not infectable:
		push_warning("Node " + str(target) + " is not a child of an Infectable node!")
		return null
	var infection := infectable.get_node(nodepath_infection) as Infection
	if not infection:
		push_error("Infection node not found on Infectable node " + str(infectable))
		return null
	return infection

static func get_interactable_from(child_node : Node) -> InteractionTrigger:
	var interactable := find_parent_in_group(child_node, group_interactable)
	if not interactable:
		push_warning("Node " + str(child_node) + " is not a child of an Interactable node!")
		return null
	var trigger := interactable as InteractionTrigger
	if not trigger:
		push_error("Intaractable node " + str(interactable) + " is not an InteractionTrigger")
		return null
	return trigger
