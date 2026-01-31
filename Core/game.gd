extends Node

var player : Player


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugQuit"):
		get_tree().quit()
