extends CanvasLayer


func _on_start_pressed() -> void:
	Game.start_game()


func _on_exit_pressed() -> void:
	Game.quit_to_desktop()
