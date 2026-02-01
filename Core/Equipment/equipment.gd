class_name Equipment
extends Node

@export var equip_input_action : StringName
@export var activate_mask_index : MaskSlot.mask_type
@export var resource : EquipmentResource

signal equip_requested(equipment : Equipment)

var active := false
var transitioning := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(equip_input_action):
		equip_requested.emit(self)
		

func equip() -> void:
	transitioning = true
	await get_tree().create_timer(1.0).timeout
	transitioning = false
	active = true
	get_tree().call_group("MaskSlot","Activate",activate_mask_index)
	print("Equipped " + str(self))

func unequip() -> void:
	transitioning = true
	await get_tree().create_timer(1.0).timeout
	transitioning = false
	active = false
	print("Unequipped " + str(self))
