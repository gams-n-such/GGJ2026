class_name Vial
extends Node3D


func _on_interaction_trigger_interaction_completed() -> void:
	Game.collect_vial()
	queue_free()
