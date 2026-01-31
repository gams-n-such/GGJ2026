extends CharacterBody3D

@export_range(10,100,1) var detect_distance : float = 30.0

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
