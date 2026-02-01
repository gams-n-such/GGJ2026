class_name Weapon
extends Equipment


@export var interactor : PlayerInteractorBase

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
