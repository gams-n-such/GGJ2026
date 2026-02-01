extends Node3D


func _on_interaction_trigger_interaction_completed() -> void:
	Game.deliver_collectibles()
