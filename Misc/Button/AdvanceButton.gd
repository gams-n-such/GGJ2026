extends Button

@onready var accept: AudioStreamPlayer = $Accept
@onready var decline: AudioStreamPlayer = $Decline
@onready var hover: AudioStreamPlayer = $Hover


func _on_mouse_entered() -> void:
	hover.play()

func _on_pressed() -> void:
	if disabled:
		decline.play()
	else:
		accept.play()
