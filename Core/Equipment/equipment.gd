class_name Equipment
extends Node

@export var equip_input_action : StringName
@export var resource : EquipmentResource

signal equip_requested(equipment : Equipment)

var active := false
var transitioning := false

func can_be_used() -> bool:
	return active and not transitioning

func _input(event: InputEvent) -> void:
	if not equip_input_action.is_empty() and event.is_action_pressed(equip_input_action):
		try_equip()

func try_equip() -> void:
	equip_requested.emit(self)

func equip() -> void:
	transitioning = true
	await get_tree().create_timer(1.0).timeout
	transitioning = false
	active = true
	print("Equipped " + str(self))

func unequip() -> void:
	transitioning = true
	await get_tree().create_timer(1.0).timeout
	transitioning = false
	active = false
	print("Unequipped " + str(self))
