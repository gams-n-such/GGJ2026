extends Node3D

@onready var infection: Infection = $Infection
@onready var sprite: Sprite3D = $Sprite3D

@export var none_infection : Texture2D
@export var half_infection : Texture2D
@export var full_infection : Texture2D

var phase

func _on_infection_infection_state_changed() -> void:
	if infection.progress == 0:
		phase = 0
		sprite.material_override.albedo_texture = none_infection
	elif infection.progress == 1:
		phase = 1
		sprite.material_override.albedo_texture = half_infection
	elif infection.progress == 2:
		phase = 2
		sprite.material_override.albedo_texture = full_infection


func _on_area_3d_body_entered(body: Node3D) -> void:
	Utils.deal_damage(body,1)
