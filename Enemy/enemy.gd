extends CharacterBody3D

@onready var sprite_3d: Sprite3D = $Sprite3D

@export_range(10,100,1) var detect_distance : float = 30.0

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if position.distance_to(player.global_position) >= detect_distance:
		look_at(player.global_position)

func _process(delta: float) -> void:
	var camera_pos = get_viewport().get_camera().global_transform.origin
	camera_pos.y = 0
	look_at(camera_pos, Vector3.UP)
	pass
