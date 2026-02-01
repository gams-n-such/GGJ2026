class_name Mask
extends Equipment

@export var activate_mask_index : MaskSlot.mask_type

var target_camera : Camera3D:
	get:
		return Game.player.camera

var mask_resource : MaskResource:
	get:
		return resource as MaskResource

const MASK_HUD = preload("uid://cgo0lnpaha2ki")

func equip() -> void:
	transitioning = true
	var hud := MASK_HUD.instantiate() as MaskHud
	Game.player.add_child(hud)
	await hud.play_equip_transition(false)
	hud.queue_free()
	transitioning = false
	active = true
	target_camera.cull_mask = mask_resource.visible_layers
	get_tree().call_group("MaskSlot", "Activate", activate_mask_index)
	print("Equipped " + str(self))

func unequip() -> void:
	transitioning = true
	var hud := MASK_HUD.instantiate() as MaskHud
	Game.player.add_child(hud)
	await hud.play_equip_transition(true)
	hud.queue_free()
	transitioning = false
	active = false
	target_camera.cull_mask = Game.default_camera_layers
	print("Unequipped " + str(self))
