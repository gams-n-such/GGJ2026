class_name AttributeMod
extends Node

@export var info : AttributeModInfo

var attribute : Attribute:
	get:
		return get_parent() as Attribute

var type : AttributeModInfo.ModType:
	get:
		return info.mod_type

var value : float:
	get:
		return info.mod_value

func remove() -> void:
	if attribute:
		attribute.remove_modifier(self)
