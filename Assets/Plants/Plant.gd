extends Node3D

@onready var infection: Infection = $Infection
@onready var sprite: Sprite3D = $Sprite3D

@export var none_infection : Texture2D
@export var half_infection : Texture2D
@export var full_infection : Texture2D

func _on_infection_infection_state_changed() -> void:
	if infection.progress == 0:
		sprite.material_override.albedo_texture = none_infection
	elif infection.progress == 1:
		sprite.material_override.albedo_texture = half_infection
	elif infection.progress == 2:
		sprite.material_override.albedo_texture = full_infection
