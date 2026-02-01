extends Node3D

@onready var infection: Infection = $Infection
@onready var sprite: Sprite3D = %Sprite3D

@export var none_infection : Texture2D
@export var half_infection : Texture2D
@export var full_infection : Texture2D

var phase

@export var damage : float = 2.0

func _on_infection_infection_state_changed() -> void:
	match infection.progress:
		Infection.Progress.NONE:
			phase = 0
			sprite.material_override.albedo_texture = none_infection
		Infection.Progress.HALF:
			phase = 1
			sprite.material_override.albedo_texture = half_infection
		Infection.Progress.FULL:
			phase = 2
			sprite.material_override.albedo_texture = full_infection


func _on_area_3d_body_entered(body: Node3D) -> void:
	if infection.is_infected() and body is Player:
		dot(Game.player)
		%DamageTimer.start()

func dot(player : Player) -> void:
	Utils.deal_damage(player, damage)


func _on_damage_timer_timeout() -> void:
	dot(Game.player)


func _on_trigger_body_exited(body: Node3D) -> void:
	if infection.is_infected() and body is Player:
		dot(Game.player)
		%DamageTimer.stop()
