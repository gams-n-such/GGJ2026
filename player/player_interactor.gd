class_name PlayerInteractorBase
extends RayCast3D

@onready var interaction_timer : Timer = %InteractionTimer

signal potential_target_found(target : Node)
signal potential_target_lost()
signal interaction_ended(target : Node, success : bool)

var potential_target : InteractionTrigger
var active_target : InteractionTrigger

func detect_target() -> InteractionTrigger:
	var target = get_collider()
	if not target:
		return null
	var shape_id = get_collider_shape()
	var owner_id = target.shape_find_owner(shape_id)
	var shape = target.shape_owner_get_owner(owner_id)
	if not shape:
		push_error("Interactor failed to detect target")
	return Utils.get_interactable_from(shape)

func _process(delta: float) -> void:
	if potential_target != detect_target():
		potential_target = detect_target()
		print(potential_target)
		if active_target and active_target != potential_target:
			interrupt_interaction()
		if not potential_target:
			potential_target_lost.emit()
		else:
			potential_target_found.emit(potential_target)

func get_time_to_interact(with : Node) -> float:
	return 1.0

func begin_interaction() -> void:
	if not potential_target:
		return
	active_target = potential_target
	var time_to_interact := get_time_to_interact(active_target)
	if time_to_interact > 0:
		interaction_timer.start(time_to_interact)
	else:
		_end_interaction(true)

func is_interacting() -> bool:
	return active_target != null

func _on_interaction_timer_timeout() -> void:
	_end_interaction(true)

func interrupt_interaction() -> bool:
	if not is_interacting():
		return false
	_end_interaction(false)
	return true

func _end_interaction(completed : bool) -> void:
	on_interaction_ended(completed)
	interaction_ended.emit(active_target, completed)
	_cleanup_interaction()

func on_interaction_ended(completed : bool) -> void:
	return

func _cleanup_interaction() -> void:
	active_target = null
	interaction_timer.stop()
