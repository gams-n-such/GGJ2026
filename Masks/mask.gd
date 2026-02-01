class_name Mask
extends Equipment

@export var activate_mask_index : MaskSlot.mask_type

var target_camera : Camera3D:
	get:
		return Game.player.camera

var mask_resource : MaskResource:
	get:
		return resource as MaskResource

@export var default_weapon : Weapon

const MASK_HUD = preload("uid://cgo0lnpaha2ki")

func equip() -> void:
	transitioning = true
	var hud := MASK_HUD.instantiate() as MaskHud
	Game.player.add_child(hud)
	await hud.play_equip_transition(false)
	hud.queue_free()
	target_camera.cull_mask = mask_resource.visible_layers
	if default_weapon:
		await (default_weapon.get_parent() as EquipmentManager).begin_equipping(default_weapon)
	transitioning = false
	active = true
	get_tree().call_group("MaskSlot", "Activate", activate_mask_index)
	print("Equipped " + str(self))

func unequip() -> void:
	transitioning = true
	var weapon_manager := default_weapon.get_parent() as EquipmentManager
	if default_weapon:
		await weapon_manager.unequip_current()
	var hud := MASK_HUD.instantiate() as MaskHud
	Game.player.add_child(hud)
	await hud.play_equip_transition(true)
	hud.queue_free()
	target_camera.cull_mask = Game.default_camera_layers
	transitioning = false
	active = false
	print("Unequipped " + str(self))
