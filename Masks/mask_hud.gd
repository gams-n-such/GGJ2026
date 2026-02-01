class_name MaskHud
extends CanvasLayer

@onready var anim_player := %AnimationPlayer

func _ready() -> void:
	#play_equip_transition(false)
	pass

func play_equip_transition(reverse : bool = false) -> void:
	anim_player.play("equip", -1, -1 if reverse else 1, reverse)
	await anim_player.animation_finished
	anim_player.play("RESET")
