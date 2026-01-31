extends Control

var is_opened : bool = false

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	#$MasterOptionsMenu.visible = false
	$Panel.visible = false
	visible = false
	is_opened = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	get_parent().layer = 5
	get_tree().paused = true
	$Panel.visible = true
	visible = true
	$AnimationPlayer.play("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("ui_escape"):
			is_opened = !is_opened
			if !is_opened:
				get_parent().layer = 1
				resume()
			else:
				pause()
				

func _on_resume_pressed() -> void:
	get_parent().layer = 1
	resume()

func _on_exit_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_options_pressed() -> void:
	#OptionsLayer.visible = true
	pass

func _notification(what):
	match what:
		#NOTIFICATION_APPLICATION_FOCUS_IN:
			#resume()
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			pause()
