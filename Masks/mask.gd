extends Equipment

var mask_resource : MaskResource:
	get:
		return resource as MaskResource

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
