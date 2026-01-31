extends CanvasLayer



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_authors_pressed() -> void:
	pass # Replace with function body.


func _on_start_pressed() -> void:
	Game.load_gameplay_scene()
