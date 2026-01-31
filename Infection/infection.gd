class_name Infection
extends Node

enum Progress { NONE, HALF, FULL }

signal infection_state_changed

@export var progress := Progress.NONE
@export var incubation_time : float = 60.0
@export var immunity_time : float = 30.0

@onready var incubation_timer : Timer = %IncubationTimer
@onready var immunity_timer : Timer = %ImmunityTimer
@onready var heal_timer : Timer = %HealTimer

#region Healing

func can_be_healed() -> bool:
	return progress == Progress.HALF

func is_immune() -> bool:
	return not immunity_timer.is_stopped()

var healing := false

func begin_healing(delay : float = 0.0) -> bool:
	if not can_be_healed():
		return false
	incubation_timer.stop()
	immunity_timer.start(immunity_time + delay)
	if delay > 0.0:
		heal_timer.start(delay)
	else:
		heal()
	return true

func heal() -> void:
	progress = Progress.NONE

func _on_heal_timer_timeout() -> void:
	heal()

#endregion

#region Infection

func is_infected() -> bool:
	return progress != Progress.NONE

func can_be_infected() -> bool:
	return not is_immune() and not is_infected()

func infect() -> bool:
	if is_infected():
		return false
	progress = Progress.HALF
	incubation_timer.start(incubation_time)
	return true

func _on_incubation_timer_timeout() -> void:
	progress = Progress.FULL

#endregion
