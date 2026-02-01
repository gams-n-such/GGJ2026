extends PlayerInteractorBase


func begin_interaction() -> void:
	var infection := Utils.find_infection_component(potential_target)
	if infection:
		super.begin_interaction()

func on_interaction_ended(completed : bool) -> void:
	super.on_interaction_ended(completed)
	if completed:
		var infection := Utils.find_infection_component(active_target)
		infection.begin_healing(0.0)
