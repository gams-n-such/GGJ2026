extends Node3D

func _process(delta: float) -> void:
	look_at(get_camera_global_position(), Vector3.UP)

func get_camera_global_position() -> Vector3:
	if get_viewport():
		if get_viewport().get_camera_3d():
			return get_viewport().get_camera_3d().global_position
	push_warning("Fail")
	return Vector3.ZERO
