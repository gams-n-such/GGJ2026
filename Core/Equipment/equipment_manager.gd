class_name EquipmentManager
extends Node

var current_equipment : Equipment
var queued_equipment : Equipment

signal equipped(new_equipment : Equipment)

func _ready() -> void:
	for child in get_children():
		var equipment := child as Equipment
		if equipment:
			equipment.equip_requested.connect(_on_equip_requested)


func _on_equip_requested(equipment : Equipment) -> void:
	begin_equipping(equipment)

func begin_equipping(equipment : Equipment) -> void:
	queued_equipment = equipment
	if current_equipment:
		if current_equipment.active and not current_equipment.transitioning:
			if equipment == current_equipment:
				# Already equipped
				return
			else:
				await unequip_current()
		else:
			# Already queued new equip, will be donned after transition is complete
			return
	current_equipment = queued_equipment
	queued_equipment = null
	if current_equipment:
		current_equipment.equip()
	if queued_equipment:
		# If new equipment was queued already, we immediately proceed to equip it
		begin_equipping(queued_equipment)

func unequip_current() -> void:
	if current_equipment:
		await current_equipment.unequip()
		current_equipment = null
