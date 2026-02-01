extends PlayerInteractorBase


@onready var cooldown_timer : Timer = %CooldownTimer

@export var damage : float = 10.0
@export var cooldown : float = 0.5

func is_on_cooldown() -> bool:
	return not cooldown_timer.is_stopped()

func begin_interaction() -> void:
	if is_on_cooldown():
		return
	else:
		super.begin_interaction()

func on_interaction_ended(completed : bool) -> void:
	super.on_interaction_ended(completed)
	Utils.deal_damage(active_target, damage)
	if completed:
		cooldown_timer.start(cooldown)
