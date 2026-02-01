extends advance_button

@export var bus_name :String = "Music"
@export var bus_index: int

@export var muted_icon : AtlasTexture
@export var unmuted_icon :AtlasTexture

func _ready():
	# Get the index of the bus by name
	bus_index = AudioServer.get_bus_index(bus_name)

## Call this to mute (turn off)
#func mute_bus():
	#AudioServer.set_bus_mute(bus_index, true)
#
## Call this to unmute (turn on)
#func unmute_bus():
	#AudioServer.set_bus_mute(bus_index, false)

# Call this to toggle the state
func toggle_bus():
	var is_muted = AudioServer.is_bus_mute(bus_index)
	AudioServer.set_bus_mute(bus_index, not is_muted)
	
	if is_muted: icon = unmuted_icon
	else: icon = muted_icon

func _pressed() -> void:
	
	toggle_bus()
