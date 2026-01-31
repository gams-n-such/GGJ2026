extends Node3D

enum PickupType { PART, CAPSULE }

@export var type : PickupType
var collected := false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if collected:
		return
	if Utils.get_player_from(body):
		collected = true
		Game.collect_part()
		# TODO: hide instead of detroying?
		queue_free()
