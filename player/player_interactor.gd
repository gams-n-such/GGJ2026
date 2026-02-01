class_name PlayerInteractorBase
extends RayCast3D

@onready var interaction_timer : Timer = %InteractionTimer

signal potential_target_found(target : Node)
signal potential_target_lost()
signal interaction_started(target : Node, time_left : float)
signal interaction_ended(target : Node, success : bool)

var potential_target : Node
var active_target : Node

@export var target_group := Utils.group_interactable
@export var cooldown : float = -1.0

@onready var cooldown_timer : Timer = %CooldownTimer


func detect_target() -> Node:
	var target = get_collider()
	if not target:
		return null
	var shape_id = get_collider_shape()
	var owner_id = target.shape_find_owner(shape_id)
	var shape = target.shape_owner_get_owner(owner_id)
	if not shape:
		push_error("Interactor failed to detect target")
	if target_group.is_empty():
		return shape as Node
	else:
		return Utils.find_parent_in_group(shape, target_group)

func _process(delta: float) -> void:
	if potential_target != detect_target():
		potential_target = detect_target()
		if active_target and active_target != potential_target:
			interrupt_interaction()
		if not potential_target:
			potential_target_lost.emit()
		else:
			potential_target_found.emit(potential_target)

func get_time_to_interact(with : Node) -> float:
	var interactable := with as InteractionTrigger
	if interactable:
		return interactable.interaction_time
	return -1.0

func is_on_cooldown() -> bool:
	return not cooldown_timer.is_stopped()

func begin_interaction() -> void:
	if not potential_target:
		return
	if is_on_cooldown():
		return
	active_target = potential_target
	on_interaction_started()
	var time_to_interact := get_time_to_interact(active_target)
	interaction_started.emit(active_target, time_to_interact)
	if time_to_interact > 0:
		interaction_timer.start(time_to_interact)
	else:
		_end_interaction(true)

func on_interaction_started() -> void:
	var interactable := active_target as InteractionTrigger
	if interactable:
		interactable.interaction_started.emit()

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
	var interactable := active_target as InteractionTrigger
	if interactable:
		if completed:
			interactable.interaction_completed.emit()
		else:
			interactable.interaction_aborted.emit()
	if completed:
		cooldown_timer.start(cooldown)

func _cleanup_interaction() -> void:
	active_target = null
	interaction_timer.stop()
