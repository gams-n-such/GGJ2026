extends PlayerInteractorBase


@export var damage : float = 10.0

func on_interaction_ended(completed : bool) -> void:
	super.on_interaction_ended(completed)
	if completed:
		Utils.deal_damage(active_target, damage)
